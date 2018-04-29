desc "Refresh and store ending current EHP for all players"
task :ehp_end => :environment do
    plyr = PlayersController.new
    plyr.ehp_end
end