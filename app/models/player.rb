require 'open-uri'

class Player < ActiveRecord::Base
  
  SKILLS = ["attack", "strength", "defence", "hitpoints", "ranged", "prayer",
            "magic", "cooking", "woodcutting", "fishing", "firemaking", "crafting",
            "smithing", "mining", "runecraft", "overall"]
  
  TIMES = ["day", "week", "month", "year"]

  # This is the canonical list of supporter. It is used to generate the list
  # of supporters on both home page and the about us page. It also contains
  # the flair image and other styling applied to supporters names wherever
  # they appear.
  # Adding a new supporter:
  #   1. Add a new entry this list as a hash {name: "supporter_name"}
  #   2. Add an image after their name by adding the key :flair_after
  #   3. Add an image before their  name by adding the key :flair_before
  #   4. Apply arbitrary css by adding the key :other_css
  #   5. If any new images were required, be sure to add them to app/assests/images
  SUPPORTERS = [{name: "Bargan"},
                {name: "Freckled Kid", flair_after: "flairs/burnt_bones.png"},
                {name: "Obor", flair_before: "flairs/shamanmask.png", flair_after: "flairs/oborclub.png"},
                {name: "Gl4Head", flair_after: "flairs/fighting_boots.png"},
                {name: "Ikiji", flair_after: "flairs/Mystery_box.png"},
                {name: "Xan So", flair_after: "items/Maple_shortbow.png"},
                {name: "Netbook Pro", flair_after: "flairs/malta_flag.png"},
                {name: "F2P Lukie", flair_after: "flairs/tea.png"},
                {name: "Tame My Wild", flair_after: "flairs/dog.png"},
                {name: "FitMC", flair_after: "flairs/anchovy_pizza.png"},
                {name: "Pink skirt", flair_after: "flairs/pink_skirt.png"},
                {name: "UIM STK F2P", flair_after: "items/Rune_scimitar.gif"},
                {name: "MA5ON", flair_after: "items/Diamond.gif"},
                {name: "For Ulven", flair_after: "flairs/wolf.png"},
                {name: "tannerdino", flair_after: "items/Mossy_key.png"},
                {name: "Playing Fe", flair_after: "flairs/salmon.png"},
                {name: "Pawz", flair_after: "flairs/rs3helm.png"},
                {name: "Yellow bead", flair_after: "flairs/yellow_bead.png"},
                {name: "ZINJAN", flair_after: "flairs/ZINJANTHROPI.png"},
                {name: "Valleyman6", flair_after: "flairs/uk_flag.png"},
                {name: "Snooz Button", flair_after: "flairs/macaroni.png"},
                {name: "IronMace Din", flair_after: "flairs/maceblur2.png"},
                {name: "HCIM_btw_fev", flair_after: "flairs/kitten.png"},
                {name: "citnA", flair_after: "flairs/bronzehelm.png"},
                {name: "Lea Sinclair", flair_after: "flairs/cupcake.png"},
                {name: "lRAIDERSS", flair_after: "flairs/raiders3.png"},
                {name: "Sofacanlazy", flair_after: "flairs/australia-flag.png"},
                {name: "I love rs", flair_after: "flairs/tank.png"},
                {name: "Say F2p Ult", flair_after: "flairs/santa.png"},
                {name: "Irish Woof", flair_after: "flairs/leprechaun2.png"},
                {name: "Faij", flair_after: "flairs/frog.png"},
                {name: "Leftoverover", flair_after: "flairs/rope.png"},
                {name: "DJ9", flair_after: "flairs/death_rune.png"},
                {name: "Drae", flair_after: "flairs/rsz_dshield.png"},
                {name: "David BBQ", flair_after: "flairs/cooked_chicken.png"},
                {name: "Schwifty Bud", flair_after: "flairs/rick_sanchez.png", other_css: ["font-family: Script", "font-variant: small-caps"]},
                {name: "UI Pain", flair_after: "flairs/steel_axe.png"},
                {name: "Fe F2P", flair_after: "flairs/skulled.png"},
                {name: "WishengradHC", flair_after: "flairs/bowser.png"},
                {name: "n4ckerd", flair_after: "items/Gilded_med_helm.png"},
                {name: "Tohno1612", flair_after: "flairs/addy_helm.png"},
                {name: "H C Gilrix", flair_after: "flairs/HCIM.png"},
                {name: "Frogmask", flair_after: "flairs/frog.png"},
                {name: "NoQuestsHCIM", flair_after: "flairs/noquest.png"},
                {name: "Adentia", flair_after: "flairs/danish_flag.png"},
                {name: "threewaygang"},
                {name: "5perm sock"},
                {name: "Sir BoJo", flair_after: "items/Rune_mace.gif"},
                {name: "f2p Ello", flair_after: "items/Book_of_knowledge.png"},
                {name: "Ghost Bloke", flair_after: "flairs/ghost_bloke.png"},
                {name: "Fe Apes", flair_after: "flairs/fe_apes.jpg"},
                {name: "Iron of One", flair_after: "items/Dark_cavalier.png"},
                {name: "InsurgentF2P", flair_after: "skills/defence.png"},
                {name: "cwismis noob", flair_after: "flairs/christmas_tree.png"},
                {name: "Sad Jesus", flair_after: "flairs/sad_jesus.png"},
                {name: "SapphireHam", flair_after: "items/Coal.gif"},
                {name: "Doublessssss"},
                {name: "ColdFingers1", flair_after: "flairs/ColdFingers1.png"},
                {name: "xmymwf609"},
                {name: "Cas F2P HC", flair_after: "items/Big_bones.gif"},
                {name: "Onnn", flair_after: "flairs/canada-flag.png"},
                {name: "Shade_Core", flair_after: "flairs/shade_core.png"},
                {name: "Metan"},
                {name: "F2P UIM OREO", flair_after: "flairs/f2p_uim_oreo.jpg"},
                {name: "Crawler", flair_after: "flairs/flesh_crawler.png"},
                {name: "UIM Dakota", flair_after: "flairs/Cadava_berries.png"},
                {name: "HCBown"},
                {name: "Dukeddd"},
                {name: "one a time"},
                {name: "Yewsless", flair_after: "items/Yew_logs.gif"},
                {name: "Wizards Foot", flair_after: "flairs/Wizards_Foot_flair.png"},
                {name: "F2P Jords", flair_after: "flairs/Druidic_wreath.png"},
                {name: "a q p IM"},
                {name: "Hardcore VFL", flair_after: "HCIM.png"},
                {name: "Pizzarrhea", flair_after: "flairs/pizzarrhea.gif"},
                {name: "bemanisows", flair_after: "flairs/vannaka.png"},
                {name: "Dusty Lime", flair_after: "items/Rune_chainbody.gif"},
                {name: "Brantrout", flair_after: "items/Trout.gif"},
                {name: "f2p uim nerd"},
                {name: "Romans ch 12"},
                {name: "Feature", flair_after: "flairs/camel.png"},
                {name: "Arizer Air", flair_after: "flairs/chicken_wing.png"},
                {name: "Irondish", flair_after: "flairs/egg.png"},
                {name: "Maze", flair_after: "flairs/mysterious.png"},
                {name: "P1J"},
                {name: "Earfs"},
                {name: "the f2p uim", flair_after: "flairs/Green_partyhat.png"},
                {name: "ColdFingers3", flair_after: "flairs/Snow_imp_gloves.png"},
                {name: "i drink fiji", flair_after: "flairs/blue_cape.png"},
                {name: "Kill the Ego"},
                {name: "BALN"},
                {name: "Steel Afro"},
                {name: "minlvlskilla", flair_after: "flairs/3.png"},
                {name: "DansPotatoe", flair_after: "items/Potato.png"},
                {name: "UncleTomas", flair_after: "flairs/shade_robe.png"},
                {name: "Brim haven", flair_after: "flairs/ceres.png"},
                {name: "Your Bearr", flair_after: "flairs/Bear_feet.png"},
                {name: "GOLB f2p", flair_after: "flairs/golb_f2p.png"},
                {name: "Kristelee"},
                {name: "Politiken", flair_after: "flairs/danish_flag.png"},
                {name: "Ticket Farm", flair_after: "flairs/genie_head.png"},
                {name: "UIM TMW"}]

  def self.skills()
    SKILLS
  end

  def self.times()
    TIMES
  end

  def self.supporters_hashes()
    SUPPORTERS
  end

  def self.supporters()
    SUPPORTERS.map{|supporter| supporter[:name]}
  end
  
  def self.sql_supporters()
    quoted_names = supporters.map{ |name| "'#{name}'" }
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
  
  def check_hc_death(stats_hash)
    if player_acc_type == "HCIM"
      begin
        im_uri = URI.parse("https://services.runescape.com/m=hiscore_oldschool_ironman/index_lite.ws?player=#{self.player_name}")
        im_stats = im_uri.read.split(" ")
        im_xp = im_stats[0].split(",")[2].to_f
        hc_uri = URI.parse("https://services.runescape.com/m=hiscore_oldschool_hardcore_ironman/index_lite.ws?player=#{self.player_name}")
        hc_stats = hc_uri.read.split(" ")
        hc_xp = hc_stats[0].split(",")[2].to_f
        if hc_xp < (im_xp - 1000000) or (im_xp - hc_xp).to_f/hc_xp > 0.05
          stats_hash["player_acc_type"] = "IM"
        end
      rescue Exception => e
        puts e.message
      ensure
        return stats_hash
      end
    end

    return stats_hash
  end
  
  def check_p2p(stats_hash)
    return stats_hash["potential_p2p"].to_f > 0
  end

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
    
    stats_hash["combat_lvl"] = combat
    return stats_hash
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
  
  def remove_cutoff(stats_hash)
    if stats_hash["overall_ehp"] < 1
      Player.where(player_name: player_name).destroy_all
      return true
    end
  end
  
  def update_player
    if F2POSRSRanks::Application.config.downcase_fakes.include?(player_name.downcase)
      Player.where(player_name: player_name).destroy_all
    end
    puts "updating #{player_name}"
    all_stats = get_stats
    if all_stats == false
      update_attributes(:potential_p2p => 1)
      return false
    end
    stats_hash = Player.parse_raw_stats(all_stats)
    bonus_xp = calc_bonus_xps(stats_hash)
    stats_hash = calc_ehp(stats_hash)
    stats_hash = adjust_bonus_xp(stats_hash, bonus_xp)

    stats_hash = check_hc_death(stats_hash)
    stats_hash = calc_combat(stats_hash)
    
    stats_hash["ttm_lvl"] = time_to_max(stats_hash, "lvl")
    stats_hash["ttm_xp"] = time_to_max(stats_hash, "xp")

    if stats_hash["overall_ehp"] > 250 or Player.supporters.include?(player_name)
      TIMES.each do |time|
        xp = self.read_attribute("overall_xp_#{time}_start")
        if xp.nil? or xp == 0
          stats_hash = update_player_start_stats(time, stats_hash)
        end
      end
      
      stats_hash = check_record_gains(stats_hash)
    end

    self.attributes = stats_hash
    self.save :validate => false
  end
  
  def check_record_gains(stats_hash)
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
          stats_hash["#{skill}_xp_#{time}_max"] = xp - start_xp
        end
        if max_ehp.nil? or ehp - start_ehp > max_ehp
          stats_hash["#{skill}_ehp_#{time}_max"] = ehp - start_ehp
        end
      end
    end

    return stats_hash
  end
  
  def update_player_start_stats(time, stats_hash)
    SKILLS.each do |skill|
      xp = self.read_attribute("#{skill}_xp")
      ehp = self.read_attribute("#{skill}_ehp")
      stats_hash["#{skill}_xp_#{time}_start"] = xp
      stats_hash["#{skill}_ehp_#{time}_start"] = ehp
    end

    return stats_hash
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
    ehp = get_ehp_type
    ttm = 0
    F2POSRSRanks::Application.config.skills.each do |skill|
      if skill != "p2p" and skill != "overall" and skill != "lms" and skill != "p2p_minigame" and skill != "clues_all" and skill != "clues_beginner"
        skill_xp = stats_hash["#{skill}_xp"]
        if lvl_or_xp == "lvl" and skill_xp >= 13034431
          next
        elsif lvl_or_xp == "xp" and skill_xp == 200000000
          next
        end

        skill_ehp = stats_hash["#{skill}_ehp"]
        adjusted_skill_ehp = calc_skill_ehp(skill_xp, ehp["#{skill}_tiers"], ehp["#{skill}_xphrs"])
        if lvl_or_xp == "lvl"
          max_ehp = calc_max_lvl_ehp(ehp["#{skill}_tiers"], ehp["#{skill}_xphrs"])
        else
          max_ehp = calc_max_xp_ehp(ehp["#{skill}_tiers"], ehp["#{skill}_xphrs"])
        end
        
        max_ehp = (max_ehp*100).floor/100.0

        if max_ehp > adjusted_skill_ehp
          ttm += max_ehp - adjusted_skill_ehp
        end
      end
    end
    return ttm
  end
  
  def get_bonus_xp
    case player_acc_type
    when "Reg"
      bonus_xp = F2POSRSRanks::Application.config.bonus_xp_reg
    when "HCIM", "IM"
      bonus_xp = F2POSRSRanks::Application.config.bonus_xp_iron
    when "UIM"
      bonus_xp = F2POSRSRanks::Application.config.bonus_xp_uim
    end
    return bonus_xp
  end
  
  # Returns hash in the following format. 
  # "bonus_for": {bonus_from: expected_xp_in_bonus_for, bonus_from: xp, ...}
  # bonuses: {
  #   "prayer": {"attack": 123, "defence": 12, "strength": 12, ...},
  #   "smithing": {"crafting": 123456},
  #   ...
  # }
  def calc_bonus_xps(stats_hash)
    bonus_xps = get_bonus_xp
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
  
  def self.parse_raw_stats(all_stats)
    stats_hash = Hash.new
    stats_hash["potential_p2p"] = 0
    F2POSRSRanks::Application.config.skills.each.with_index do |skill, skill_idx|
      skill_lvl = all_stats[skill_idx].split(",")[1].to_f
      skill_xp = all_stats[skill_idx].split(",")[2].to_i
      skill_rank = all_stats[skill_idx].split(",")[0].to_i
      
      skill_lvl = 0 if skill_lvl < 0
      skill_xp = 0 if skill_xp < 0
      skill_rank = 0 if skill_rank < 0
      
      if skill == "hitpoints" and skill_lvl < 10
        skill_lvl = 10
        skill_xp = 1154
      end
      
      if skill == "p2p" 
        stats_hash["potential_p2p"] += skill_xp
      elsif skill == "p2p_minigame"
        stats_hash["potential_p2p"] += skill_lvl
      elsif skill == "lms"
        next
      elsif skill == "clues_all" or skill == "clues_beginner"
        stats_hash[skill] = [skill_lvl, 0].max
        stats_hash["#{skill}_rank"] = skill_rank
      else
        stats_hash["#{skill}_lvl"] = skill_lvl
        stats_hash["#{skill}_xp"] = skill_xp
        stats_hash["#{skill}_rank"] = skill_rank
      end
    end
    return stats_hash
  end
  
  def calc_ehp(stats_hash)
    ehp = get_ehp_type
    total_ehp = 0.0
    total_lvl = 8
    total_xp = 0
    stats_list = F2POSRSRanks::Application.config.f2p_skills
    
    stats_list.each.with_index do |skill, skill_idx|
      skill_lvl = stats_hash["#{skill}_lvl"]
      skill_xp = stats_hash["#{skill}_xp"]
      
      skill_tiers = ehp["#{skill}_tiers"]
      skill_xphrs = ehp["#{skill}_xphrs"]
      skill_ehp = calc_tiered_ehp(skill_tiers, skill_xphrs, skill_xp)

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
    ehp = get_ehp_type
    bonus_xp_list = get_bonus_xp
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
  
  def calc_tiered_ehp(skill_tiers, skill_xphrs, skill_xp)
    skill_ehp = 0.0
    skill_tiers.each.with_index do |skill_tier, tier_idx|
      skill_tier = skill_tier.to_f
      skill_xphr = skill_xphrs[tier_idx].to_f
      if skill_xphr != 0 and skill_tier < skill_xp
        if (tier_idx + 1) < skill_tiers.length and skill_xp >=  skill_tiers[tier_idx + 1]
          skill_ehp += (skill_tiers[tier_idx+1].to_f - skill_tier)/skill_xphr
        else
          skill_ehp += (skill_xp - skill_tier)/skill_xphr
        end
      end
    end
    return skill_ehp
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
      puts "CML API unresponsive."
      return false
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
    unless recs
      return
    end
    
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

  def recalculate_ehp
    skill_hash = {}
    ehp = get_ehp_type
    TIMES.each do |time|
      start_stats_hash = {}
      SKILLS.each do |skill|
        start_xp = self.read_attribute("#{skill}_xp_#{time}_start")
        start_stats_hash["#{skill}_xp"] = start_xp
        start_stats_hash["#{skill}_lvl"] = 1
      end
      bonus_xp = calc_bonus_xps(start_stats_hash)
      start_stats_hash = calc_ehp(start_stats_hash)
      start_stats_hash = adjust_bonus_xp(start_stats_hash, bonus_xp)

      SKILLS.each do |skill|
        skill_hash["#{skill}_ehp_#{time}_start"] = start_stats_hash["#{skill}_ehp"]
      end
    end
    update_attributes(skill_hash)
  end
  
  def self.get_stats(name, acc_type)
    if name == "Bargan"
      all_stats = "-1,1410,143408971 -1,99,13078967 -1,99,13068172 -1,99,13069431 -1,99,14171944 -1,85,3338143 -1,82,2458698 -1,99,13065371 -1,99,14018193 -1,91,6111148 -1,-1,0 -1,92,6557350 -1,99,14021572 -1,99,13074360 -1,99,13182234 -1,81,2195415 -1,-1,0 -1,-1,0 -1,-1,0 -1,-1,0 -1,-1,0 -1,80,1997973 -1,-1,0 -1,-1,0 -1,-1 -1,-1 -1,-1 -1,-1 -1,-1 -1,-1 -1,-1 -1,-1 -1,-1 -1,-1".split(" ")
    else
      begin
        case acc_type
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
  
  def self.acc_type_xp(name, acc_type)
    stats = self.get_stats(name, acc_type)
    return 0 if not stats
    return stats[0].split(",")[2].to_f
  end
  
  def self.determine_acc_type(name)
    uim_xp = acc_type_xp(name, "UIM")
    hcim_xp = acc_type_xp(name, "HCIM")
    im_xp = acc_type_xp(name, "IM")
    reg_xp = acc_type_xp(name, "Reg")
    if uim_xp > 0 and uim_xp >= reg_xp and uim_xp >= im_xp
      return "UIM"
    elsif hcim_xp > 0 and hcim_xp >= reg_xp and hcim_xp >= im_xp
      return "HCIM"
    elsif im_xp > 0 and im_xp >= reg_xp
      return "IM"
    elsif reg_xp > 0 
      return "Reg"
    else
      return nil
      # raise "Account type cannot be determined."
    end
  end

  def self.check_p2p(stats)
    return stats["potential_p2p"] > 0
  end

  def self.create_new(name)  
    name = self.sanitize_name(name)
    found = self.find_player(name)
    if found
      return "exists"
    elsif F2POSRSRanks::Application.config.downcase_fakes.include?(name.downcase)
      return "p2p"
    end

    acc_type = self.determine_acc_type(name)
    if acc_type.nil?
      return nil
    end

    stats = self.get_stats(name, acc_type)
    stats = self.parse_raw_stats(stats)
    
    if self.check_p2p(stats)
      return "p2p"
    end

    Player.create!({"player_name" => name, "player_acc_type" => acc_type})
    player = Player.find_player(name)
    result = player.update_player
    return player
  end

  def count_99
    count = 0

    (SKILLS - ["overall"]).each do |skill|
      count += 1 if self.read_attribute("#{skill}_lvl") >= 99
    end

    return count
  end

  def count_200m
    count = 0

    (SKILLS - ["overall"]).each do |skill|
      count += 1 if self.read_attribute("#{skill}_xp") >= 200000000
    end

    return count
  end
end
