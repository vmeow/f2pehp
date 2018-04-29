desc "Refreshes and store starting current EHP for all players"
task :ehp_start => :environment do
    plyr = PlayersController.new
    plyr.refresh_players
    plyr.ehp_start
end