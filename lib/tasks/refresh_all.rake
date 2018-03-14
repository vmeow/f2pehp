desc "Update stats for all players"
task :refresh_players => :environment do
    plyr = PlayersController.new
    plyr.refresh_players
end