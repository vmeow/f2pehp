require "open-uri"

supporters = ["Bargan",
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
              "5perm_sock",
              "Sir BoJo",
              "f2p Ello"]

SUPPORTERS = "("
supporters.each do |name|
  SUPPORTERS += "'#{name}'," 
end
SUPPORTERS = "#{SUPPORTERS[0...-1]})"

namespace :players do
  desc "Update stats for all players"
  task :update_all => :environment do
    Player.all.find_in_batches(batch_size: 25) do |batch|
      batch.each do |player|
        begin
          player.update_player
        rescue
          next
        end
      end
    end
  end
  
  desc "Update stats for players with over 250 overall EHP"
  task :update_top => :environment do
    Player.where("overall_ehp > 250 OR player_name IN #{SUPPORTERS}").find_in_batches(batch_size: 25) do |batch|
      batch.each do |player|
        begin
          player.update_player
        rescue
          next
        end
      end
    end
  end
  
  desc "Update day stats for players with over 250 overall EHP"
  task :start_day => :environment do
    Player.where("overall_ehp > 250 OR player_name IN #{SUPPORTERS}").find_in_batches(batch_size: 25) do |batch|
      batch.each do |player|
        begin
          player.update_player_start_stats("day")
        rescue
          next
        end
      end
    end
  end
  
  desc "Update week stats for players with over 250 overall EHP"
  task :start_week => :environment do
    Player.where("overall_ehp > 250 OR player_name IN #{SUPPORTERS}").find_in_batches(batch_size: 25) do |batch|
      batch.each do |player|
        begin
          player.update_player_start_stats("week")
        rescue
          next
        end
      end
    end
  end
  
  desc "Update month stats for players with over 250 overall EHP"
  task :start_month => :environment do
    Player.where("overall_ehp > 250 OR player_name IN #{SUPPORTERS}").find_in_batches(batch_size: 25) do |batch|
      batch.each do |player|
        begin
          player.update_player_start_stats("month")
        rescue
          next
        end
      end
    end
  end
  
  desc "Update year stats for players with over 250 overall EHP"
  task :start_year => :environment do
    Player.where("overall_ehp > 250 OR player_name IN #{SUPPORTERS}").find_in_batches(batch_size: 25) do |batch|
      batch.each do |player|
        begin
          player.update_player_start_stats("year")
        rescue
          next
        end
      end
    end
  end
  
  desc "Update correct day/week/month/year stats for players with over 250 overall EHP"
  task :start_stats => :environment do
    Player.where("overall_ehp > 250 OR player_name IN #{SUPPORTERS}").find_in_batches(batch_size: 25) do |batch|
      batch.each do |player|
        begin
          player.update_player_start_stats("day")
          
          if Time.now.gmtime.wday == 1
            player.update_player_start_stats("week")
          end
          
          if Time.now.gmtime.day == 1
            player.update_player_start_stats("month")
          end

          if Time.now.gmtime.month == 1 and Time.now.gmtime.day == 1
            player.update_player_start_stats("year")
          end
        rescue
          next
        end
      end
    end
  end
end