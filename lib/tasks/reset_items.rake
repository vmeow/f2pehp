desc "Update item prices"
task :update_prices => :environment do
  load Rails.root.join('update_prices.rb')
end

