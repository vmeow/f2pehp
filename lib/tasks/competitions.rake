namespace :competitions do
  desc "Set starting current EHP for all players"
  task :set_start_ehp => :environment do
    Player.all.find_in_batches(batch_size: 25) do |batch|
      batch.each do |player|
        begin
          player.update_attribute(:overall_ehp_start, player['overall_ehp'].to_f)
          player.update_attribute(:mining_ehp_start, player['mining_ehp'].to_f)
          player.update_attribute(:fishing_ehp_start, player['fishing_ehp'].to_f)
          player.update_attribute(:woodcutting_ehp_start, player['woodcutting_ehp'].to_f)
          player.update_attribute(:firemaking_ehp_start, player['firemaking_ehp'].to_f)
          player.update_attribute(:cooking_ehp_start, player['cooking_ehp'].to_f)
        rescue
          next
        end
      end
    end
  end
  
  desc "Set ending current EHP for all players"
  task :set_end_ehp => :environment do
    Player.all.find_in_batches(batch_size: 25) do |batch|
      batch.each do |player|
        begin
          player.update_attribute(:overall_ehp_end, player['overall_ehp'].to_f)
          player.update_attribute(:mining_ehp_end, player['mining_ehp'].to_f)
          player.update_attribute(:fishing_ehp_end, player['fishing_ehp'].to_f)
          player.update_attribute(:woodcutting_ehp_end, player['woodcutting_ehp'].to_f)
          player.update_attribute(:firemaking_ehp_end, player['firemaking_ehp'].to_f)
          player.update_attribute(:cooking_ehp_end, player['cooking_ehp'].to_f)
        rescue
          next
        end
      end
    end
  end
end