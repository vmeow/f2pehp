desc "Refreshes and store starting current EHP for all players"
task :ehp_start => :environment do
    plyr = PlayersController.new
    plyr.refresh_250
    plyr.ehp_start
    plyr.refresh_end_250
    plyr.ehp_start
end