require "open-uri"

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
  
  desc "Update stats for players with over 200 overall EHP"
  task :update_top => :environment do
    Player.where("overall_ehp > 200").find_in_batches(batch_size: 25) do |batch|
      batch.each do |player|
        begin
          player.update_player
        rescue
          next
        end
      end
    end
  end
end