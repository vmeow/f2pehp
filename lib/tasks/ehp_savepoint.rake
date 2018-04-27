desc "Store current EHP for all players"
task :ehp_savepoint => :environment do
    plyr = PlayersController.new
    plyr.ehp_savepoint
end