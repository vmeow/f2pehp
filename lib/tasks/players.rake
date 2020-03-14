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

  desc "Update stats for players with over 250 overall EHP"
  task :update_top => :environment do
    Player.where("overall_ehp > 250 OR player_name IN #{Player.sql_supporters}").find_in_batches(batch_size: 25) do |batch|
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
    Player.where("overall_ehp > 250 OR player_name IN #{Player.sql_supporters}").find_in_batches(batch_size: 25) do |batch|
      batch.each do |player|
        begin
          stats_hash = player.update_player_start_stats("day", {})
          player.update_attributes(stats_hash)
        rescue
          next
        end
      end
    end
  end

  desc "Update week stats for players with over 250 overall EHP"
  task :start_week => :environment do
    Player.where("overall_ehp > 250 OR player_name IN #{Player.sql_supporters}").find_in_batches(batch_size: 25) do |batch|
      batch.each do |player|
        begin
          stats_hash = player.update_player_start_stats("week", {})
          player.update_attributes(stats_hash)
        rescue
          next
        end
      end
    end
  end

  desc "Update month stats for players with over 250 overall EHP"
  task :start_month => :environment do
    Player.where("overall_ehp > 250 OR player_name IN #{Player.sql_supporters}").find_in_batches(batch_size: 25) do |batch|
      batch.each do |player|
        begin
          stats_hash = player.update_player_start_stats("month", {})
          player.update_attributes(stats_hash)
        rescue
          next
        end
      end
    end
  end

  desc "Update year stats for players with over 250 overall EHP"
  task :start_year => :environment do
    Player.where("overall_ehp > 250 OR player_name IN #{Player.sql_supporters}").find_in_batches(batch_size: 25) do |batch|
      batch.each do |player|
        begin
          stats_hash = player.update_player_start_stats("year", {})
          player.update_attributes(stats_hash)
        rescue
          next
        end
      end
    end
  end

  desc "Update correct day/week/month/year stats for players with over 250 overall EHP"
  task :start_stats => :environment do
    Player.where("overall_ehp > 250 OR player_name IN #{Player.sql_supporters}").find_in_batches(batch_size: 25) do |batch|
      batch.each do |player|
        begin
          stats_hash = player.update_player_start_stats("day", {})

          if Time.now.gmtime.wday == 1
            stats_hash = player.update_player_start_stats("week", stats_hash)
          end

          if Time.now.gmtime.day == 1
            stats_hash = player.update_player_start_stats("month", stats_hash)
          end

          if Time.now.gmtime.month == 1 and Time.now.gmtime.day == 1
            stats_hash = player.update_player_start_stats("year", stats_hash)
          end

          player.update_attributes(stats_hash)
        rescue
          next
        end
      end
    end
  end

  desc "Recalculate starting EHP from current EHP and bonus XP"
  task :recalc_ehp => :environment do
    Player.where("overall_ehp > 250 OR player_name IN #{Player.sql_supporters}").find_in_batches(batch_size: 25) do |batch|
      batch.each do |player|
        begin
          player.recalculate_ehp
        rescue
          next
        end
      end
    end
  end

  desc "Repair records from CML."
  task :repair_records => :environment do
    Player.where("overall_ehp > 250 OR player_name IN #{Player.sql_supporters}").find_in_batches(batch_size: 25) do |batch|
      batch.each do |player|
        begin
          player.repair_records
        rescue
          next
        end
      end
    end
  end

  desc 'Repair player names.'
  task repair_names: :environment do
    Player.select(:id, :player_name).find_each do |player|
      begin
        name = Hiscores.get_registered_player_name(player.player_name)
        player.update_attribute(:player_name, name) if name
      rescue
        next
      end
    end
  end
end
