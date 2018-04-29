desc "Refresh and store ending current EHP for all players"
task :ehp_end => :environment do
    plyr = PlayersController.new
    plyr.refresh_250
    plyr.ehp_end
    plyr.refresh_end_250
    plyr.ehp_end
end