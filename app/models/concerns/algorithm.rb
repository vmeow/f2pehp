module Algorithm
  include EHP, Skill, Parser

  def calc_combat(stats_hash)
    att = stats_hash["attack_lvl"]
    str = stats_hash["strength_lvl"]
    defence = stats_hash["defence_lvl"]
    hp = stats_hash["hitpoints_lvl"]
    ranged = stats_hash["ranged_lvl"]
    magic = stats_hash["magic_lvl"]
    pray = stats_hash["prayer_lvl"]
    
    base = 0.25 * (defence + hp + (pray/2).floor)
    melee = 0.325 * (att + str)
	  range = 0.325 * ((ranged/2).floor + ranged)
	  mage = 0.325 * ((magic/2).floor + magic)
    combat = (base + [melee, range, mage].max).round(5)
    
    if combat < 3.4
      combat = 3.4
    end
    
    return combat
  end
  
  def calc_skill_ehp(xp, tiers, xphrs)
    ehp = 0
    tiers.each.with_index do |tier, idx|
      tier = tier.to_f
      xphr = xphrs[idx].to_f
      if xphr != 0 and tier < xp
        if (idx+1) < tiers.length and xp >=  tiers[idx+1]
          ehp += (tiers[idx+1].to_f - tier)/xphr
        else
          ehp += (xp.to_f - tier)/xphr
        end
      end
    end
    return ehp
  end
  
  def calc_max_lvl_ehp(tiers, xphrs)
    return calc_skill_ehp(13034431, tiers, xphrs)
  end
  
  def calc_max_xp_ehp(tiers, xphrs)
    return calc_skill_ehp(200000000, tiers, xphrs)
  end
  
  def time_to_max(stats_hash, lvl_or_xp)
    ehp = get_ehp_type(player_acc_type)
    ttm = 0
    get_f2p_skills.each do |skill|
      skill_ehp = stats_hash["#{skill}_ehp"]
      if lvl_or_xp == "lvl"
        max_ehp = calc_max_lvl_ehp(ehp["#{skill}_tiers"], ehp["#{skill}_xphrs"])
      else
        max_ehp = calc_max_xp_ehp(ehp["#{skill}_tiers"], ehp["#{skill}_xphrs"])
      end
      
      max_ehp = (max_ehp*100).floor/100.0

      if max_ehp > skill_ehp
        ttm += max_ehp - skill_ehp
      end
    end
    return ttm
  end
  
  # Returns hash in the following format. 
  # "bonus_for": {bonus_from: expected_xp_in_bonus_for, bonus_from: xp, ...}
  # bonuses: {
  #   "prayer": {"attack": 123, "defence": 12, "strength": 12, ...},
  #   "smithing": {"crafting": 123456},
  #   ...
  # }
  def calc_bonus_xps(stats_hash)
    bonus_xps = get_bonus_xp(player_acc_type)
    bonuses = {}
    bonus_xps.each do |ratio, bonus_for, bonus_from, start_xp, end_xp|
      skill_from = stats_hash["#{bonus_from}_xp"]     
      if skill_from <= start_xp.to_i
        next
      end
      
      bonus_xp = [([skill_from, end_xp].min - start_xp.to_i)*ratio.to_f, 200000000].min
      
      if bonuses[bonus_for] and bonuses[bonus_for][bonus_from]
        bonuses[bonus_for][bonus_from] += bonus_xp
      elsif bonuses[bonus_for]
        bonuses[bonus_for][bonus_from] = bonus_xp
      else
        bonuses[bonus_for] = {"#{bonus_from}" => bonus_xp}
      end
    end
    return bonuses
  end
  
  def calc_ehp(stats_hash)
    ehp = get_ehp_type(player_acc_type)
    total_ehp = 0.0
    total_lvl = 8
    total_xp = 0

    get_f2p_skills.each.with_index do |skill, skill_idx|
      skill_lvl = stats_hash["#{skill}_lvl"]
      skill_xp = stats_hash["#{skill}_xp"]
      
      skill_tiers = ehp["#{skill}_tiers"]
      skill_xphrs = ehp["#{skill}_xphrs"]
      skill_ehp = calc_skill_ehp(skill_xp, skill_tiers, skill_xphrs)

      stats_hash["#{skill}_ehp"] = skill_ehp.round(2)
      total_ehp += skill_ehp.round(2)
      total_xp += skill_xp
      total_lvl += skill_lvl
    end
    
    stats_hash["overall_ehp"] = total_ehp.round(2)
    
    if stats_hash["overall_lvl"] < 34
      stats_hash["overall_lvl"] = total_lvl
      stats_hash["overall_xp"] = total_xp
    end

    return stats_hash
  end
  
  def adjust_bonus_xp(stats_hash, bonus_xp)
    ehp = get_ehp_type(player_acc_type)
    bonus_xp_list = get_bonus_xp(player_acc_type)
    bonus_xp.keys.each do |bonus_for|
      if bonus_for == "magic"
        next
      end

      skill_xp = stats_hash["#{bonus_for}_xp"]
      skill_ehp = stats_hash["#{bonus_for}_ehp"]
      skill_tiers = ehp["#{bonus_for}_tiers"]
      skill_xphrs = ehp["#{bonus_for}_xphrs"]
      actual_xp = skill_xp

      # get expected total bonus xp discrepancy
      bonus_xp[bonus_for].keys.each do |bonus_from|
        expected_xp = bonus_xp[bonus_for][bonus_from]
        actual_xp -= expected_xp
      end

      # calc ehp discrepancy
      if actual_xp < 0
        xp_discrepancy = -actual_xp
        if skill_xphrs == [0]
          if bonus_for == "firemaking"
            skill_xphrs = [144600]
            skill_ehp = skill_xp/144600
          elsif bonus_for == "cooking"
            skill_xphrs = [120000]
            skill_ehp = skill_xp/120000
          end
        end
        ehp_discrepancy = calc_skill_ehp(skill_xp + xp_discrepancy, skill_tiers, skill_xphrs) - skill_ehp
      else
        xp_discrepancy = 0
        ehp_discrepancy = 0
      end

      # subtract ehp discrepancy from the bonus_for skill if multiskill bonuses
      if bonus_xp[bonus_for].size > 1
        bonus_for_ehp = stats_hash["#{bonus_for}_ehp"]
        if bonus_for_ehp < ehp_discrepancy
          # puts "1 Subtracting #{ehp_discrepancy} ehp discrepancy and #{bonus_for_ehp} #{bonus_for} from overall_ehp."
          stats_hash["overall_ehp"] = (stats_hash["overall_ehp"] - ehp_discrepancy - bonus_for_ehp).round(2)
          stats_hash["#{bonus_for}_ehp"] = 0
        else
          # puts "2 Subtracting #{ehp_discrepancy} from #{bonus_for} ehp."
          stats_hash["#{bonus_for}_ehp"] = (stats_hash["#{bonus_for}_ehp"] - ehp_discrepancy).round(2)
          stats_hash["overall_ehp"] = (stats_hash["overall_ehp"] - ehp_discrepancy).round(2)
        end
      else
        bonus_from = bonus_xp[bonus_for].keys[0]
        bonus_from_ehp = stats_hash["#{bonus_from}_ehp"]
        if bonus_from_ehp < ehp_discrepancy
          # puts "3 Subtracting #{ehp_discrepancy} ehp discrepancy and #{bonus_from_ehp} #{bonus_from} from overall_ehp."
          stats_hash["overall_ehp"] = (stats_hash["overall_ehp"] - ehp_discrepancy - bonus_from_ehp).round(2)
          stats_hash["#{bonus_from}_ehp"] = 0
        else
          # puts "4 Subtracting #{ehp_discrepancy} discrepancy from #{bonus_from} ehp."
          stats_hash["#{bonus_from}_ehp"] = (stats_hash["#{bonus_from}_ehp"] - ehp_discrepancy).round(2)
          stats_hash["overall_ehp"] = (stats_hash["overall_ehp"] - ehp_discrepancy).round(2)
        end
      end
    end
    return stats_hash
  end
  
  def get_repaired_tracking(acc_type, time)
    xps = get_cml_xp(time)
    xp_start = {}
    
    get_skills.each do |skill|
      xp_start = xp_start.merge({"#{skill}_xp_#{time}_start" => xps["#{skill}_xp"].to_i})
    end
    
    ehp = get_ehp_type(acc_type)
    ehp_start = {}
    (get_skills - ["overall"]).each do |skill|
      skill_ehp = calc_skill_ehp(xps["#{skill}_xp"].to_i, ehp["#{skill}_tiers"], ehp["#{skill}_xphrs"])
      ehp_start = ehp_start.merge({"#{skill}_ehp_#{time}_start" => skill_ehp})
    end
    ehp_start["overall_ehp_#{time}_start"] = ehp_start.values.sum

    return xp_start.merge(ehp_start)
  end
  
  def get_repaired_records(name, acc_type)
    recs = get_cml_records(name)
    unless recs
      return
    end
    
    ehp = get_ehp_type(acc_type)
    ehp_recs = {}
    (TIMES - ["year"]).each do |time|
      time_recs = {}
      (get_skills - ["overall"]).each do |skill|
        xp_gain = recs["#{skill}_xp_#{time}_max"].to_i
        curr_xp = self.read_attribute("#{skill}_xp")
        before_xp = curr_xp - xp_gain
        before_ehp = calc_skill_ehp(before_xp, ehp["#{skill}_tiers"], ehp["#{skill}_xphrs"])
        curr_ehp = calc_skill_ehp(curr_xp, ehp["#{skill}_tiers"], ehp["#{skill}_xphrs"])
        ehp_gain = (curr_ehp - before_ehp).round(2)
        time_recs = time_recs.merge({"#{skill}_ehp_#{time}_max" => ehp_gain})
      end
      ehp_recs = ehp_recs.merge(time_recs)
      ehp_recs["overall_ehp_#{time}_max"] = time_recs.values.max
    end
    
    recs_hash = recs.merge(ehp_recs)
    return recs_hash
  end

  def get_recalculated_ehp(acc_type)
    skill_hash = {}
    ehp = get_ehp_type(acc_type)
    get_times.each do |time|
      start_stats_hash = {}
      get_skills.each do |skill|
        start_xp = self.read_attribute("#{skill}_xp_#{time}_start")
        start_stats_hash["#{skill}_xp"] = start_xp
        start_stats_hash["#{skill}_lvl"] = 1
      end
      bonus_xp = calc_bonus_xps(start_stats_hash)
      start_stats_hash = calc_ehp(start_stats_hash)
      start_stats_hash = adjust_bonus_xp(start_stats_hash, bonus_xp)

      get_skills.each do |skill|
        skill_hash["#{skill}_ehp_#{time}_start"] = start_stats_hash["#{skill}_ehp"]
      end
    end
    return skill_hash
  end
end
