desc "Delete players with 0 ehp from database."
task :delete_nil => :environment do
    plyr = PlayersController.new
    plyr.delete_nil
end