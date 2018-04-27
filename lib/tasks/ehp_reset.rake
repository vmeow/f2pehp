desc "Set starting current EHP to 0 for all players"
task :ehp_reset => :environment do
    plyr = PlayersController.new
    plyr.ehp_reset
end