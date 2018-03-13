class ItemsController < ApplicationController
  def update_prices
    summary = URI.parse('https://rsbuddy.com/exchange/summary.json')
    @prices = JSON.parse(summary.read.gsub('\"', '"'))
    @items = Item.all
    @items.each do |item|
      current_price = @prices["#{item.itemid}"]["overall_average"].to_f
      icon_name = item.name.gsub("_", " ")
      item.update_attribute(:icon, "items/#{icon_name}.gif")
      
      if current_price == 0
        item_response = URI.parse("http://services.runescape.com/m=itemdb_oldschool/api/catalogue/detail.json?item=#{item.itemid}")
        item_json = JSON.parse(item_response.read.gsub('\"', '"'))
        ge_price = item_json["item"]["current"]["price"].gsub(",", "").to_f
        item.update_attribute(:current, ge_price)
      else
        item.update_attribute(:current, current_price)
      end      

    end
  end
end
