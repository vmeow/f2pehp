desc "Delete players with 0 ehp from database."
task :ehp_reset => :environment do
    plyr = PlayersController.new
    plyr.delete_nil
end