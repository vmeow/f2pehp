desc "Store starting current EHP for all players"
task :ehp_start => :environment do
    plyr = PlayersController.new
    plyr.refresh_all
    plyr.ehp_start
end