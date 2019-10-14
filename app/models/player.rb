require 'open-uri'

class Player < ActiveRecord::Base

  SKILLS = ["attack", "strength", "defence", "hitpoints", "ranged", "prayer",
            "magic", "cooking", "woodcutting", "fishing", "firemaking", "crafting",
            "smithing", "mining", "runecraft", "overall"]

  TIMES = ["day", "week", "month", "year"]

  ACCOUNT_TYPES = %w[Reg IM HCIM UIM]
  ACCOUNT_TYPE_ANCESTORS = {
    UIM: %w[IM Reg],
    HCIM: %w[IM Reg],
    IM: %w[Reg]
  }

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
  SUPPORTERS = [{name: "Bargan", amount: 145.99, date: "2018-02-02"},
                {name: "Vagae", amount: 100, date: "2019-08-25", flair_after: "flairs/Strange_skull.png"},
                {name: "Ikiji", amount: 86.59, date: "2018-09-12", flair_after: "flairs/Mystery_box.png"},
                {name: "a q p IM"},
                {name: "Netbook Pro", flair_after: "flairs/malta_flag.png"},
                {name: "tannerdino", amount: 7.69, date: "2018-11-14", flair_after: "items/Mossy_key.png"},
                {name: "Anonymous", amount: 60, date: "2018-01-31", no_link: true},
                {name: "Obor", amount: 60, date: "2018-01-31", flair_before: "flairs/shamanmask.png", flair_after: "flairs/oborclub.png"},
                {name: "Pawz", amount: 55.5, date: "2018-02-01", flair_after: "flairs/rs3helm.png"},
                {name: "Freckled Kid", amount: 41.85, flair_after: "flairs/burnt_bones.png"},
                {name: "Gl4Head", amount: 30, flair_after: "flairs/fighting_boots.png"},
                {name: "Romans ch 12", amount: 30, date: "2019-04-13"},
                {name: "DJ9", amount: 30, date: "2018-04-18", flair_after: "flairs/death_rune.png"},
                {name: "cwismis noob", flair_after: "flairs/christmas_tree.png"},
                {name: "Crawler", flair_after: "flairs/flesh_crawler.png"},
                {name: "Ticket Farm", date: "2019-07-05", flair_after: "flairs/genie_head.png"},
                {name: "Wooper", flair_after: "flairs/wooper.png"},
                {name: "Earfs"},
                {name: "minlvlskilla", flair_after: "flairs/3.png"},
                {name: "Fe F2P", amount: 25, date: "2018-06-21", flair_after: "flairs/skulled.png"},
                {name: "Anonymous", amount: 20, date: "2019-07-19", no_link: true},
                {name: "Xan So", amount: 15, date: "2018-11-13", flair_after: "items/Maple_shortbow.png"},
                {name: "ColdFingers3", amount: 15, date: "2019-04-29", flair_after: "flairs/Snow_imp_gloves.png"},
                {name: "Brim haven", amount: 15, date: "2019-05-31", flair_after: "flairs/ceres.png"},
                {name: "Yewsless", amount: 11, date: "2018-03-11", flair_after: "items/Yew_logs.gif"},
                {name: "F2P Lukie", amount: 10, date: "2018-01-31", flair_after: "flairs/tea.png"},
                {name: "Tame My Wild", amount: 10, date: "2018-02-06", flair_after: "flairs/dog.png"},
                {name: "Faij", amount: 10, date: "2018-03-06", flair_after: "flairs/frog.png"},
                {name: "Frogmask", flair_after: "flairs/frog.png"},
                {name: "FitMC", amount: 10, date: "2018-03-13", flair_after: "flairs/anchovy_pizza.png"},
                {name: "Pink skirt", amount: 10, date: "2018-05-18", flair_after: "flairs/pink_skirt.png"},
                {name: "UIM STK F2P", amount: 10, date: "2018-09-20", flair_after: "items/Rune_scimitar.gif"},
                {name: "MA5ON", amount: 10, date: "2018-11-15", flair_after: "items/Diamond.gif"},
                {name: "NoQuestsHCIM", amount: 10, date: "2018-12-02", flair_after: "flairs/noquest.png"},
                {name: "Sir BoJo", amount: 10, date: "2018-12-03", flair_after: "items/Rune_mace.gif"},
                {name: "f2p Ello", amount: 10, date: "2018-12-05", flair_after: "items/Book_of_knowledge.png"},
                {name: "Sad Jesus", amount: 10, date: "2019-01-19", flair_after: "flairs/sad_jesus.png"},
                {name: "Cas F2P HC", amount: 10, date: "2019-01-30", flair_after: "items/Big_bones.gif"},
                {name: "UIM Dakota", amount: 10, date: "2019-02-26", flair_after: "flairs/Cadava_berries.png"},
                {name: "F2P Jords", amount: 10, date: "2019-03-17", flair_after: "flairs/Druidic_wreath.png"},
                {name: "Feature", amount: 10, date: "2019-14-04", flair_after: "flairs/camel.png"},
                {name: "Steel Afro", amount: 10, date: "2019-05-16"},
                {name: "Your Bearr", amount: 10, date: "2019-06-04", flair_after: "flairs/Bear_feet.png"},
                {name: "UIM TMW", amount: 10, date: "2019-07-19"},
                {name: "Bonk Loot", amount: 10, date: "2019-08-27", flair_after: "flairs/Amulet_of_power.png"},
                {name: "iron korbah", amount: 10, date: "2019-09-27"},
                {name: "Iron of One", amount: 9, date: "2018-12-24", flair_after: "items/Dark_cavalier.png"},
                {name: "Ghost Bloke", amount: 8, date: "2018-12-13", flair_after: "flairs/ghost_bloke.png"},
                {name: "For Ulven", amount: 7.77, date: "2018-03-11", flair_after: "flairs/wolf.png"},
                {name: "Fe Apes", amount: 7.69, date: "2018-12-14", flair_after: "flairs/fe_apes.jpg"},
                {name: "Playing Fe", amount: 7, date: "2018-04-26", flair_after: "flairs/salmon.png"},
                {name: "ZINJAN", amount: 6.66, date: "2018-05-18", flair_after: "flairs/ZINJANTHROPI.png"},
                {name: "Snooz Button", amount: 6.66, date: "2018-06-03", flair_after: "flairs/macaroni.png"},
                {name: "Valleyman6", amount: 6.64, date: "2018-06-15", flair_after: "flairs/uk_flag.png"},
                {name: "i drink fiji", amount: 6, date: "2018-05-06", flair_after: "flairs/blue_cape.png"},
                {name: "Uxeef", amount: 5.96, date: "2018-09-17"},
                {name: "Adentia", amount: 5.55, date: "2018-12-03", flair_after: "flairs/danish_flag.png"},
                {name: "threewaygang"},
                {name: "Yellow bead", amount: 5.38, date: "2018-05-02", flair_after: "flairs/yellow_bead.png"},
                {name: "IronMace Din", amount: 5, date: "2018-02-18", flair_after: "flairs/maceblur2.png"},
                {name: "HCIM_btw_fev", amount: 5, date: "2018-02-05", flair_after: "flairs/kitten.png"},
                {name: "citnA", amount: 5, date: "2018-02-06", flair_after: "flairs/bronzehelm.png"},
                {name: "Lea Sinclair", amount: 5, date: "2018-02-09", flair_after: "flairs/cupcake.png"},
                {name: "lRAIDERSS", amount: 5, date: "2018-02-10", flair_after: "flairs/raiders3.png"},
                {name: "Sofacanlazy", amount: 5, date: "2018-02-11", flair_after: "flairs/australia-flag.png"},
                {name: "I love rs", amount: 5, date: "2018-02-18", flair_after: "flairs/tank.png"},
                {name: "Say F2p Ult", amount: 5, date: "2018-03-01", flair_after: "flairs/santa.png"},
                {name: "Irish Woof", amount: 5, date: "2018-03-04", flair_after: "flairs/leprechaun2.png"},
                {name: "Leftoverover", amount: 5, date: "2018-04-04", flair_after: "flairs/rope.png"},
                {name: "Drae", amount: 5, date: "2018-05-08", flair_after: "flairs/rsz_dshield.png"},
                {name: "David BBQ", amount: 5, date: "2018-05-18", flair_after: "flairs/cooked_chicken.png"},
                {name: "Schwifty Bud", amount: 5, date: "2018-05-26", flair_after: "flairs/rick_sanchez.png", other_css: ["font-family: Script", "font-variant: small-caps"]},
                {name: "UI Pain", amount: 5, date: "2018-06-10", flair_after: "flairs/steel_axe.png"},
                {name: "oLd Sko0l", amount: 5, date: "2018-09-16"},
                {name: "WishengradHC", amount: 5, date: "2018-10-23", flair_after: "flairs/bowser.png"},
                {name: "n4ckerd", amount: 5, date: "2018-11-17", flair_after: "items/Gilded_med_helm.png"},
                {name: "InsurgentF2P", amount: 5, date: "2019-01-01", flair_after: "skills/defence.png"},
                {name: "SapphireHam", amount: 5, date: "2019-01-11", flair_after: "items/Coal.gif"},
                {name: "Doublessssss", amount: 5, date: "2019-01-12"},
                {name: "xmymwf609", amount: 5, date: "2019-01-24"},
                {name: "Onnn", amount: 5, date: "2019-02-03", flair_after: "flairs/canada-flag.png"},
                {name: "Shade_Core", date: "2019-02-08", amount: 5, flair_after: "flairs/shade_core.png"},
                {name: "Metan", amount: 5, date: "2019-02-13"},
                {name: "F2P UIM OREO", amount: 5, date: "2019-02-18", flair_after: "flairs/f2p_uim_oreo.jpg"},
                {name: "HCBown", amount: 5, date: "2019-03-04"},
                {name: "Dukeddd", amount: 5, date: "2019-03-06"},
                {name: "one a time", amount: 5, date: "2019-03-06"},
                {name: "DansPotatoe", date: "2019-03-13", flair_after: "items/Potato.png"},
                {name: "Wizards Foot", amount: 5, date: "2019-03-15", flair_after: "flairs/Wizards_Foot_flair.png"},
                {name: "Hardcore VFL", amount: 5, date: "2019-03-23", flair_after: "HCIM.png"},
                {name: "Pizzarrhea", amount: 5, date: "2019-03-23", flair_after: "flairs/pizzarrhea.gif"},
                {name: "bemanisows", amount: 5, date: "2019-03-26", flair_after: "flairs/vannaka.png"},
                {name: "Dusty Lime", amount: 5, date: "2019-03-27", flair_after: "items/Rune_chainbody.gif"},
                {name: "Brantrout", amount: 5, date: "2019-04-02", flair_after: "items/Trout.gif"},
                {name: "f2p uim nerd", amount: 5, date: "2019-04-09"},
                {name: "Arizer Air", amount: 5, date: "2019-04-15", flair_after: "flairs/chicken_wing.png"},
                {name: "Irondish", amount: 5, date: "2019-04-20", flair_after: "flairs/egg.png"},
                {name: "Maze", amount: 5, date: "2019-04-21", flair_after: "flairs/mysterious.png"},
                {name: "P1J", amount: 5, date: "2019-04-23"},
                {name: "the f2p uim", amount: 5, date: "2019-04-26", flair_after: "flairs/Green_partyhat.png"},
                {name: "Kill the Ego", amount: 5, date: "2019-05-12"},
                {name: "BALN", amount: 5, date: "2019-05-16"},
                {name: "GOLB f2p", amount: 5, date: "2019-06-05", flair_after: "flairs/golb_f2p.png", other_css: ["color: #66ffff"]},
                {name: "Kristelee", amount: 5, date: "2019-06-26"},
                {name: "Politiken", amount: 5, date: "2019-06-30", flair_after: "flairs/danish_flag.png"},
                {name: "UIMfreebie", amount: 5, date: "2019-08-24", flair_after: "flairs/Fancy_boots.png"},
                {name: "jane uwu", amount: 5, date: "2019-08-28", flair_after: "flairs/Dutch_flag.png"},
                {name: "ginormouskat", amount: 5, date: "2019-09-28"},
                {name: "Tohno1612", amount: ??, flair_after: "flairs/addy_helm.png"},
                {name: "H C Gilrix", amount: 2.5, date: "2018-03-04", flair_after: "flairs/HCIM.png"},
                {name: "Anonymous", amount: 2.5, date: "2018-07-26", no_link: true},
                {name: "Roavar", amount: 1.5, date: "2019-08-14", flair_after: "flairs/roavar.png"},
                {name: "ColdFingers1", amount: 1, date: "2019-01-15", flair_after: "flairs/ColdFingers1.png"},
                {name: "5perm sock"},
              ]

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

  def self.account_types
    ACCOUNT_TYPES
  end

  def self.account_type_ancestors
    ACCOUNT_TYPE_ANCESTORS
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

  def hcim_dead?
    # Skip check for UIMs who can never have been HCIMs.
    return false if player_acc_type == 'UIM'

    Hiscores.hcim_dead?(player_name)
  end

  def check_p2p(stats_hash)
    return stats_hash[:potential_p2p] > 0
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

    begin
      stats_hash = Hiscores.fetch_stats(player_acc_type, player_name, parse: true)
    rescue
      update_attributes(potential_p2p: 1)
      return false
    end

    bonus_xp = calc_bonus_xps(stats_hash)
    stats_hash = calc_ehp(stats_hash)
    stats_hash = adjust_bonus_xp(stats_hash, bonus_xp)

    # Check of current saved account type is still valid.
    updated_acc_type = Hiscores.verify_account_type(player_acc_type, player_name)
    if player_acc_type != updated_acc_type
      stats_hash.merge!(player_acc_type: updated_acc_type)
    end

    # Check if HCIM has died on the overall hiscore table.
    # Normally this should have been picked up by the `verify_account_type`
    # call, but this is sometimes not reliable.
    if player_acc_type == 'HCIM' && updated_acc_type == 'HCIM' && hcim_dead?
      stash_hash[:player_acc_type] = 'IM'
    end

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
      xp = stats_hash["#{skill}_xp"] || self.read_attribute("#{skill}_xp")
      ehp = stats_hash["#{skill}_ehp"] || self.read_attribute("#{skill}_ehp")
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
      xp = stats_hash["#{skill}_xp"] || self.read_attribute("#{skill}_xp")
      ehp = stats_hash["#{skill}_ehp"] || self.read_attribute("#{skill}_ehp")
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

  def self.check_p2p(stats)
    return stats[:potential_p2p] > 0
  end

  def self.create_new(name)
    name = self.sanitize_name(name)
    found = self.find_player(name)
    if found
      return "exists"
    elsif F2POSRSRanks::Application.config.downcase_fakes.include?(name.downcase)
      return "p2p"
    end

    acc_type = Hiscores.determine_account_type(name)
    return unless acc_type

    stats = Hiscores.fetch_stats(acc_type, name, parse: true)

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

  def lowest_lvl
    skill_lvls = (SKILLS - ["overall"]).each.map { |skill| self.read_attribute("#{skill}_lvl").to_i }
    return skill_lvls.min
  end
end
