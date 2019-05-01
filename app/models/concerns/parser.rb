require 'open-uri'

module Parser
  include Skill
  
  def get_stats(name, acc_type)
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
  
  def parse_raw_stats(all_stats)
    stats_hash = Hash.new
    stats_hash["potential_p2p"] = 0

    get_api_skills.each.with_index do |skill, skill_idx|
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

  def get_cml_xp(name, time)
    today = DateTime.now
    month = today.month
    year = today.year
    
    if time == "year"
      time_diff = (today - DateTime.new(year, 1, 1)).to_i
    elsif time == "month"
      time_diff = (today - DateTime.new(year, month, 1)).to_i
    end
    time_string = "#{time_diff}d"
    
    uri = URI.parse("https://crystalmathlabs.com/tracker/api.php?type=datapoints&player=#{name}&time=#{time_string}")
    begin
      retries ||= 0
      xps = uri.read.split(" ")[1]
    rescue
      sleep(10)
      retry if (retries += 1) < 5
      puts "CML tracking API unresponsive."
      return false
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
  
  def get_cml_records(name)
    uri = URI.parse("https://crystalmathlabs.com/tracker/api.php?type=recordsofplayer&player=#{name}")
    begin
      retries ||= 0
      player_records = uri.read
    rescue
      sleep(10)
      retry if (retries += 1) < 5
      puts "CML records API unresponsive."
      return false
    end
    return parse_cml_records(player_records)
  end
  
  def parse_cml_records(player_records)
    player_records = player_records.split("\n")
    recs = {}
    player_records.each.with_index do |rec, idx|
      skill = get_api_skills[idx]
      if get_skills.include?(skill)
        skill_recs = rec.split(",")
        skill_recs_hash = {"#{skill}_xp_day_max" => skill_recs[0],
                           "#{skill}_xp_week_max" => skill_recs[2],
                           "#{skill}_xp_month_max" => skill_recs[4]
                          }
        recs = recs.merge(skill_recs_hash)
      end
    end

    return recs
  end
end
