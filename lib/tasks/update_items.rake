desc "Update prices for all items"
task :update_items => :environment do
    itemsc = ItemsController.new
    itemsc.update_prices
end