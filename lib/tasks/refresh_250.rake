desc "Update stats for players with >500 EHP"
task :refresh_250 => :environment do
    plyr = PlayersController.new
    plyr.refresh_250
end