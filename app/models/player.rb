class Player < ActiveRecord::Base
  def refresh_players
    Player.all.each do |player|
      player.update_attribute(:potential_p2p, "0")
      case player.player_acc_type
      when "Reg"
        ehp = F2POSRSRanks::Application.config.ehp_reg
      when "HCIM", "IM"
        ehp = F2POSRSRanks::Application.config.ehp_iron
      when "UIM"
        ehp = F2POSRSRanks::Application.config.ehp_uim
      end
      uri = URI.parse("http://services.runescape.com/m=hiscore_oldschool/index_lite.ws?player=#{player.player_name}")
      all_stats = uri.read.split(" ")
      total_ehp = 0.0
      F2POSRSRanks::Application.config.skills.each.with_index do |skill, skill_idx|
        skill_lvl = all_stats[skill_idx].split(",")[1].to_f
        skill_xp = all_stats[skill_idx].split(",")[2].to_f
        if skill != "p2p" and skill != "overall" and skill != "lms"
          player.update_attribute(:"#{skill}_lvl", skill_lvl)
          player.update_attribute(:"#{skill}_xp", skill_xp)
        
          skill_ehp = 0.0
          skill_tiers = ehp["#{skill}_tiers"]
          skill_xphrs = ehp["#{skill}_xphrs"]
          last_skill_tier = 0.0
          skill_tiers.each.with_index do |skill_tier, tier_idx|
            skill_tier = skill_tier.to_f
            skill_xphr = skill_xphrs[tier_idx].to_f
            if skill_xphr != 0 and skill_tier < skill_xp
              if (tier_idx + 1) < skill_tiers.length and skill_xp >= skill_tiers[tier_idx + 1]
                skill_ehp += (skill_tiers[tier_idx+1].to_f - skill_tier)/skill_xphr
              else
                skill_ehp += (skill_xp.to_f - skill_tier)/skill_xphr
              end
            end
          end
          player.update_attribute(:"#{skill}_ehp", skill_ehp.round(2))
          total_ehp += skill_ehp.round(2)
        elsif skill == "p2p" and skill_xp != 0
          player.update_attribute(:potential_p2p, player.potential_p2p.to_f + skill_xp.to_f)
        end
      end
      player.update_attribute(:overall_ehp, total_ehp.round(2))
    end
  end
end
