class ItemsController < ApplicationController
  def create_items
    Item.all.each do |item|
      item.destroy
    end
    
    Item.create([
      {name: "Nature rune", itemid: 561, alch: 108},
      {name: "Green dhide body", itemid: 1135, alch: 4680},
      {name: "Green dhide chaps", itemid: 1099, alch: 2340},
      {name: "Green dhide vamb", itemid: 1065, alch: 1500},
      {name: "Gold amulet (u)", itemid: 1673, alch: 210},
      {name: "Gold amulet", itemid: 1692, alch: 210},
      {name: "Gold necklace", itemid: 1654, alch: 270},
      {name: "Gold ring", itemid: 1635, alch: 210},
      {name: "Iron platebody", itemid: 1115},
      {name: "Steel platebody", itemid: 1119, alch: 1200},
      {name: "Mithril platebody", itemid: 1121, alch: 3120},
      {name: "Adamant platebody", itemid: 1123, alch: 9984},
      {name: "Rune platebody", itemid: 1127, alch: 39000},
      {name: "Adamant platelegs", itemid: 1073, alch: 3840},
      {name: "Adamant plateskirt", itemid: 1091, alch: 3840},
      {name: "Adamant 2h sword", itemid: 1317, alch: 3840},
      {name: "Rune platelegs", itemid: 1079, alch: 38400},
      {name: "Rune plateskirt", itemid: 1093, alch: 38400},
      {name: "Rune 2h sword", itemid: 1319, alch: 38400},
      {name: "Rune dagger", itemid: 1213, alch: 4800},
      {name: "Rune sword", itemid: 1289, alch: 12480},
      {name: "Rune longsword", itemid: 1303, alch: 19200},
      {name: "Rune scimitar", itemid: 1333, alch: 15360},
      {name: "Rune axe", itemid: 1359, alch: 7680},
      {name: "Rune mace", itemid: 1432, alch: 8640},
      {name: "Rune battleaxe", itemid: 1373, alch: 24960},
      {name: "Rune warhammer", itemid: 1347, alch: 24900},
      {name: "Rune chainbody", itemid: 1113, alch: 30000},
      {name: "Rune med helm", itemid: 1147, alch: 11520},
      {name: "Rune full helm", itemid: 1163, alch: 21120},
      {name: "Rune kiteshield", itemid: 1201, alch: 32640},
      {name: "Rune pickaxe", itemid: 1275, alch: 19200},
      {name: "Iron ore", itemid: 440},
      {name: "Silver ore", itemid: 442},
      {name: "Coal", itemid: 453},
      {name: "Gold ore", itemid: 444},
      {name: "Mithril ore", itemid: 447},
      {name: "Adamantite ore", itemid: 449},
      {name: "Runite ore", itemid: 451},
      {name: "Iron bar", itemid: 2351},
      {name: "Silver bar", itemid: 2355},
      {name: "Steel bar", itemid: 2353},
      {name: "Gold bar", itemid: 2357},
      {name: "Mithril bar", itemid: 2359},
      {name: "Adamantite bar", itemid: 2361},
      {name: "Runite bar", itemid: 2363},
      {name: "Steel nails", itemid: 1539},
      {name: "Uncut sapphire", itemid: 1623},
      {name: "Uncut emerald", itemid: 1621},
      {name: "Uncut ruby", itemid: 1619},
      {name: "Uncut diamond", itemid: 1617},
      {name: "Sapphire", itemid: 1607},
      {name: "Emerald", itemid: 1605},
      {name: "Ruby", itemid: 1603},
      {name: "Diamond", itemid: 1601},
      {name: "Sapphire ring", itemid: 1637},
      {name: "Emerald ring", itemid: 1639},
      {name: "Ruby amulet (u)", itemid: 1679},
      {name: "Diamond amulet (u)", itemid: 1681},
      {name: "Logs", itemid: 1511},
      {name: "Oak logs", itemid: 1521},
      {name: "Willow logs", itemid: 1519},
      {name: "Maple logs", itemid: 1517},
      {name: "Yew logs", itemid: 1515},
      {name: "Tiara", itemid: 5525},
      {name: "Air talisman", itemid: 1438},
      {name: "Earth talisman", itemid: 1440},
      {name: "Body talisman", itemid: 1446},
      {name: "Air tiara", itemid: 5527},
      {name: "Earth tiara", itemid: 5535},
      {name: "Body tiara", itemid: 5533},
      {name: "Big bones", itemid: 532},
      {name: "Raw trout", itemid: 335},
      {name: "Raw salmon", itemid: 331},
      {name: "Raw tuna", itemid: 359},
      {name: "Raw lobster", itemid: 377},
      {name: "Raw swordfish", itemid: 371},
      {name: "Trout", itemid: 333},
      {name: "Salmon", itemid: 329},
      {name: "Tuna", itemid: 361},
      {name: "Lobster", itemid: 379},
      {name: "Swordfish", itemid: 373},
      {name: "Anchovies", itemid: 319},
      {name: "Plain pizza", itemid: 2289},
      {name: "Anchovy pizza", itemid: 2297},
      {name: "Grapes", itemid: 1987},
      {name: "Jug of water", itemid: 1937},
      {name: "Jug of wine", itemid: 1993}
    ])
  end
  
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
