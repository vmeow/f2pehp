require 'open-uri'

class Player < ActiveRecord::Base
  
  SKILLS = ["attack", "strength", "defence", "hitpoints", "ranged", "prayer",
            "magic", "cooking", "woodcutting", "fishing", "firemaking", "crafting",
            "smithing", "mining", "runecraft", "overall"]
  
  TIMES = ["day", "week", "month", "year"]
  
  SUPPORTERS = ["Bargan",
                "Freckled Kid",
                "Obor",
                "Gl4Head",
                "Ikiji",
                "Xan So",
                "Netbook Pro",
                "F2P Lukie",
                "Tame My Wild",
                "FitMC",
                "Pink skirt",
                "UIM STK F2P",
                "MA5ON",
                "For Ulven",
                "tannerdino",
                "Playing Fe",
                "Pawz",
                "Yellow bead",
                "ZINJAN",
                "Valleyman6",
                "Snooz Button",
                "IronMace Din",
                "HCIM_btw_fev",
                "citnA",
                "Lea Sinclair",
                "lRAIDERSS",
                "Sofacanlazy",
                "I love rs",
                "Say F2p Ult",
                "Irish Woof",
                "Faij",
                "Leftoverover",
                "DJ9",
                "Drae",
                "David BBQ",
                "Schwifty Bud",
                "UI Pain",
                "Fe F2P",
                "WishengradHC",
                "n4ckerd",
                "Tohno1612",
                "H C Gilrix",
                "Frogmask",
                "NoQuestsHCIM",
                "Adentia",
                "threewaygang",
                "5perm sock",
                "Sir BoJo",
                "f2p Ello",
                "Ghost Bloke",
                "Fe Apes",
                "Iron of One",
                "InsurgentF2P",
                "cwismis noob",
                "Sad Jesus",
                "SapphireHam",
                "Doublessssss",
                "ColdFingers1",
                "xmymwf609",
                "Cas F2P HC",
                "Onnn",
                "Shade_Core",
                "Metan",
                "F2P UIM OREO",
                "Crawler",
                "UIM Dakota",
                "HCBown",
                "Dukeddd",
                "one a time",
                "Yewsless",
                "Wizards Foot",
                "F2P Jords",
                "a q p IM",
                "Hardcore VFL",
                "Pizzarrhea",
                "bemanisows",
                "Dusty Lime",
                "Brantrout",
                "f2p uim nerd"]
  
  def self.supporters()
    SUPPORTERS
  end
  
  def self.sql_supporters()
    quoted_names = SUPPORTERS.map{ |name| "'#{name}'" }
    "(#{quoted_names.join(",")})"
  end
  
  # The characters +, _, \s, -, %20 count as the same when doing a lookup on hiscores.
  def self.sanitize_name(str)
    if str.downcase == "_yrak"
      return str
    else
      str = str.gsub(/[-_\\+]|(%20)/, " ")
      return str.gsub(/\A[^A-z0-9]+|[^A-z0-9\s\_-]+|[^A-z0-9]+\z/, "")
    end
  end
  
  def self.find_player(id)
    id = self.sanitize_name(id)
    player = Player.where('lower(player_name) = ?', id.downcase).first
    if player.nil?
      name = id.gsub("_", " ")
      player = Player.where('lower(player_name) = ?', name.downcase).first
    end
    if player.nil?
      name = id.gsub(" ", "_")
      player = Player.where('lower(player_name) = ?', name.downcase).first
    end
    if player.nil?
      begin
        player = Player.find(Float(id))
      rescue
        return false
      end
    end
    return player
  end
  
  def get_stats
    name = player_name
    if name == "Bargan"
      all_stats = "-1,1410,143408971 -1,99,13078967 -1,99,13068172 -1,99,13069431 -1,99,14171944 -1,85,3338143 -1,82,2458698 -1,99,13065371 -1,99,14018193 -1,91,6111148 -1,-1,0 -1,92,6557350 -1,99,14021572 -1,99,13074360 -1,99,13182234 -1,81,2195415 -1,-1,0 -1,-1,0 -1,-1,0 -1,-1,0 -1,-1,0 -1,80,1997973 -1,-1,0 -1,-1,0 -1,-1 -1,-1 -1,-1 -1,-1 -1,-1 -1,-1 -1,-1 -1,-1 -1,-1 -1,-1".split(" ")
    else
      begin
        case player_acc_type
        when "Reg"
          uri = URI.parse("https://services.runescape.com/m=hiscore_oldschool/index_lite.ws?player=#{name}")
        when "HCIM"
          uri = URI.parse("https://services.runescape.com/m=hiscore_oldschool_hardcore_ironman/index_lite.ws?player=#{name}")
        when "UIM"
          uri = URI.parse("https://services.runescape.com/m=hiscore_oldschool_ultimate/index_lite.ws?player=#{name}")
        when "IM"
          uri = URI.parse("https://services.runescape.com/m=hiscore_oldschool_ironman/index_lite.ws?player=#{name}")
        end
        all_stats = uri.read.split(" ")
      rescue Exception => e  
        puts e.message 
        return false
      end
    end
    return all_stats
  end
  
  def check_hc_death
    if player_acc_type == "HCIM"
      begin
        im_uri = URI.parse("https://services.runescape.com/m=hiscore_oldschool_ironman/index_lite.ws?player=#{self.player_name}")
        im_stats = im_uri.read.split(" ")
        im_xp = im_stats[0].split(",")[2].to_f
        hc_uri = URI.parse("https://services.runescape.com/m=hiscore_oldschool_hardcore_ironman/index_lite.ws?player=#{self.player_name}")
        hc_stats = hc_uri.read.split(" ")
        hc_xp = hc_stats[0].split(",")[2].to_f
        if hc_xp < (im_xp - 1000000)
          update_attribute(:player_acc_type, "IM")
        end
      rescue Exception => e   
        puts e.message 
      end
    end
  end
  
  def calc_ehp
    ehp = get_ehp_type
    all_stats = get_stats
    update_attribute(:potential_p2p, "0")
    total_ehp = 0.0
    total_lvl = 8
    total_xp = 0
    under_34 = false
    F2POSRSRanks::Application.config.skills.each.with_index do |skill, skill_idx|
      skill_lvl = all_stats[skill_idx].split(",")[1].to_f
      skill_xp = all_stats[skill_idx].split(",")[2].to_f
      skill_rank = all_stats[skill_idx].split(",")[0].to_f
      if skill == "hitpoints" and skill_lvl < 10
        skill_lvl = 10
        skill_xp = 1154
      end
      if skill != "p2p" and skill != "overall" and skill != "lms" and skill != "p2p_minigame" and skill != "clues_all" and skill != "clues_beginner"
        skill_ehp = 0.0
        skill_tiers = ehp["#{skill}_tiers"]
        skill_xphrs = ehp["#{skill}_xphrs"]
        skill_tiers.each.with_index do |skill_tier, tier_idx|
          skill_tier = skill_tier.to_f
          skill_xphr = skill_xphrs[tier_idx].to_f
          if skill_xphr != 0 and skill_tier < skill_xp
            if (tier_idx + 1) < skill_tiers.length and skill_xp >=  skill_tiers[tier_idx + 1]
              skill_ehp += (skill_tiers[tier_idx+1].to_f - skill_tier)/skill_xphr
            else
              skill_ehp += (skill_xp.to_f - skill_tier)/skill_xphr
            end
          end
        end
        if skill_xp < 0
          update_attribute(:"#{skill}_xp", 0)
        else
          update_attribute(:"#{skill}_xp", skill_xp)
        end
        update_attribute(:"#{skill}_lvl", skill_lvl)
        update_attribute(:"#{skill}_ehp", skill_ehp.round(2))
        update_attribute(:"#{skill}_rank", skill_rank)
        total_ehp += skill_ehp.round(2)
        total_xp += skill_xp
        total_lvl += skill_lvl
      elsif skill == "p2p" and skill_xp > 0 
        update_attribute(:potential_p2p, skill_xp)
        # Player.where(player_name: player_name).destroy_all
      elsif skill == "p2p_minigame" and skill_lvl > 0
        update_attribute(:potential_p2p, skill_lvl)
        # Player.where(player_name: player_name).destroy_all
      elsif skill == "overall"
        if skill_lvl < 34
          under_34 = true
        else
          update_attribute(:"#{skill}_lvl", skill_lvl)
          update_attribute(:"#{skill}_xp", skill_xp)
          update_attribute(:"#{skill}_rank", skill_rank)
        end
      elsif skill == "clues_all"
        update_attribute(:clues_all, [skill_lvl, 0].max)
        update_attribute(:clues_all_rank, skill_rank)
      elsif skill == "clues_beginner"
        update_attribute(:clues_beginner, [skill_lvl, 0].max)
        update_attribute(:clues_beginner_rank, skill_rank)
      end
    end
    
    update_attribute(:overall_ehp, total_ehp.round(2))
    
    if under_34
      update_attribute(:"overall_lvl", total_lvl)
      update_attribute(:"overall_xp", total_xp)
    end
      
    if potential_p2p.to_f <= 0
      update_attribute(:potential_p2p, "0")
    # else
    #   Player.where(player_name: player_name).destroy_all
    end
  end
  
  def check_p2p
    if potential_p2p.to_f > 0
      # destroy
      return true
    end
    return false
  end

  def calc_combat
    att = attack_lvl
    str = strength_lvl
    defence = defence_lvl
    hp = hitpoints_lvl
    ranged = ranged_lvl
    magic = magic_lvl
    pray = prayer_lvl
    
    base = 0.25 * (defence + hp + (pray/2).floor)
    melee = 0.325 * (att + str)
	  range = 0.325 * ((ranged/2).floor + ranged)
	  mage = 0.325 * ((magic/2).floor + magic)
    combat = (base + [melee, range, mage].max).round(5)
    
    if combat < 3.4
      combat = 3.4
    end
    
    update_attribute(:combat_lvl, combat)
  end

  def get_ehp_type
    case player_acc_type
    when "Reg"
      ehp = F2POSRSRanks::Application.config.ehp_reg
    when "HCIM", "IM"
      ehp = F2POSRSRanks::Application.config.ehp_iron
    when "UIM"
      ehp = F2POSRSRanks::Application.config.ehp_uim
    end
  end
  
  def remove_cutoff
    if overall_ehp < 1
      Player.where(player_name: player_name).destroy_all
      return true
    end
  end
  
  def update_player
    if F2POSRSRanks::Application.config.downcase_fakes.include?(player_name.downcase)
      Player.where(player_name: player_name).destroy_all
    end
    puts player_name
    all_stats = get_stats
    if all_stats == false
      update_attributes(:potential_p2p => 1)
      # Player.where(player_name: player_name).destroy_all
      return false
    end
    calc_ehp
    if check_p2p
      return "p2p"
    end
    check_hc_death
    calc_combat
    if remove_cutoff
      return "cutoff"
    end
    
    if overall_ehp > 250 or Player.supporters.include?(player_name)
      TIMES.each do |time|
        xp = self.read_attribute("overall_xp_#{time}_start")
        if xp.nil? or xp == 0
          update_player_start_stats(time)
        end
      end
      
      check_record_gains
    end
    
    update_attributes(:ttm_lvl => time_to_max("lvl"), :ttm_xp => time_to_max("xp"))
  end
  
  def check_record_gains
    SKILLS.each do |skill|
      xp = self.read_attribute("#{skill}_xp")
      ehp = self.read_attribute("#{skill}_ehp")
      TIMES.each do |time|
        start_xp = self.read_attribute("#{skill}_xp_#{time}_start")
        start_ehp = self.read_attribute("#{skill}_ehp_#{time}_start")
        max_xp = self.read_attribute("#{skill}_xp_#{time}_max")
        max_ehp = self.read_attribute("#{skill}_ehp_#{time}_max")
        if start_xp.nil? or start_ehp.nil?
          next
        end
        if max_xp.nil? or xp - start_xp > max_xp
          update_attributes("#{skill}_xp_#{time}_max" => xp - start_xp)
        end
        if max_ehp.nil? or ehp - start_ehp > max_ehp
          update_attributes("#{skill}_ehp_#{time}_max" => ehp - start_ehp)
        end
      end
    end
  end
  
  def update_player_start_stats(time)
    puts player_name
    SKILLS.each do |skill|
      xp = self.read_attribute("#{skill}_xp")
      ehp = self.read_attribute("#{skill}_ehp")
      update_attributes("#{skill}_xp_#{time}_start" => xp)
      update_attributes("#{skill}_ehp_#{time}_start" => ehp)
    end
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
  
  def time_to_max(lvl_or_xp)
    ehp = get_ehp_type
    time_to_max = 0
    F2POSRSRanks::Application.config.skills.each do |skill|
      if skill != "p2p" and skill != "overall" and skill != "lms" and skill != "p2p_minigame" and skill != "clues_all" and skill != "clues_beginner"
        skill_ehp = self.read_attribute("#{skill}_ehp")
        if lvl_or_xp == "lvl"
          max_ehp = calc_max_lvl_ehp(ehp["#{skill}_tiers"], ehp["#{skill}_xphrs"])
        else
          max_ehp = calc_max_xp_ehp(ehp["#{skill}_tiers"], ehp["#{skill}_xphrs"])
        end
        
        max_ehp = (max_ehp*100).floor/100.0

        if max_ehp > skill_ehp
          time_to_max += max_ehp - skill_ehp
          puts "#{skill}: max_ehp: #{max_ehp}, skill_ehp: #{skill_ehp}"
        end
      end
    end
    return time_to_max
  end
  
  def get_cml_xp(time)
    today = DateTime.now
    month = today.month
    year = today.year
    
    if time == "year"
      time_diff = (today - DateTime.new(year, 1, 1)).to_i
    elsif time == "month"
      time_diff = (today - DateTime.new(year, month, 1)).to_i
    end
    time_string = "#{time_diff}d"
    
    uri = URI.parse("https://crystalmathlabs.com/tracker/api.php?type=datapoints&player=#{player_name}&time=#{time_string}")
    begin
      retries ||= 0
      xps = uri.read.split(" ")[1]
    rescue
      sleep(10)
      retry if (retries += 1) < 5
      raise "CML API unresponsive."
    end
    return parse_cml_xps(xps)
  end
  
  def parse_cml_xps(xps)
    xps = xps.split(",")
    return {"overall_xp" => xps[0],
            "attack_xp" => xps[1],
            "defence_xp" => xps[2],
            "strength_xp" => xps[3],
            "hitpoints_xp" => xps[4],
            "ranged_xp" => xps[5],
            "prayer_xp" => xps[6],
            "magic_xp" => xps[7],
            "cooking_xp" => xps[8],
            "woodcutting_xp" => xps[9],
            "fishing_xp" => xps[11],
            "firemaking_xp" => xps[12],
            "crafting_xp" => xps[13],
            "smithing_xp" => xps[14],
            "mining_xp" => xps[15],
            "runecraft_xp" => xps[21]
            }
  end
  
  def repair_tracking(time)
    xps = get_cml_xp(time)
    xp_start = {}
    
    SKILLS.each do |skill|
      xp_start = xp_start.merge({"#{skill}_xp_#{time}_start" => xps["#{skill}_xp"].to_i})
    end
    
    ehp = get_ehp_type
    ehp_start = {}
    (SKILLS - ["overall"]).each do |skill|
      skill_ehp = calc_skill_ehp(xps["#{skill}_xp"].to_i, ehp["#{skill}_tiers"], ehp["#{skill}_xphrs"])
      ehp_start = ehp_start.merge({"#{skill}_ehp_#{time}_start" => skill_ehp})
    end
    ehp_start["overall_ehp_#{time}_start"] = ehp_start.values.sum

    update_attributes(xp_start.merge(ehp_start))
    return xp_start, ehp_start
  end
  
  def get_cml_records
    uri = URI.parse("https://crystalmathlabs.com/tracker/api.php?type=recordsofplayer&player=#{player_name}")
    begin
      retries ||= 0
      player_records = uri.read
    rescue
      sleep(10)
      retry if (retries += 1) < 5
      raise "CML API unresponsive."
    end
    return parse_cml_records(player_records)
  end
  
  def parse_cml_records(player_records)
    player_records = player_records.split("\n")
    recs = {}
    player_records.each.with_index do |rec, idx|
      skill = F2POSRSRanks::Application.config.skills[idx]
      if SKILLS.include?(skill)
        skill_recs = rec.split(",")
        skill_recs_hash = {"#{skill}_xp_day_max" => skill_recs[0],
                           "#{skill}_xp_week_max" => skill_recs[2],
                           "#{skill}_xp_month_max" => skill_recs[4]
                          }
        recs = recs.merge(skill_recs_hash)
      end
    end
    puts recs
    return recs
  end
  
  def repair_records
    recs = get_cml_records
    
    ehp = get_ehp_type
    ehp_recs = {}
    (TIMES - ["year"]).each do |time|
      time_recs = {}
      (SKILLS - ["overall"]).each do |skill|
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
    update_attributes(recs_hash)
    return recs_hash
  end
end
