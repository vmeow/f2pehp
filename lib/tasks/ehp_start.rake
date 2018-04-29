desc "Refreshes and store starting current EHP for all players"
task :ehp_start => :environment do
    plyr = PlayersController.new
    plyr.ehp_start
end