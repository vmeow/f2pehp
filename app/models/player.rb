require 'open-uri'

class Player < ActiveRecord::Base
  include Skill, EHP, Algorithm, Parser
  
  INTERVALS = ["day", "week", "month", "year"]
  
  SUPPORTERS = ["Bargan",
                "Freckled Kid",
                "Obor",
                "Gl4Head",
                "Ikiji",
                "Xan So",
                "Netbook Pro",
                "F2P Lukie",
                "Tame My Wild",
                "FitMC",
                "Pink skirt",
                "UIM STK F2P",
                "MA5ON",
                "For Ulven",
                "tannerdino",
                "Playing Fe",
                "Pawz",
                "Yellow bead",
                "ZINJAN",
                "Valleyman6",
                "Snooz Button",
                "IronMace Din",
                "HCIM_btw_fev",
                "citnA",
                "Lea Sinclair",
                "lRAIDERSS",
                "Sofacanlazy",
                "I love rs",
                "Say F2p Ult",
                "Irish Woof",
                "Faij",
                "Leftoverover",
                "DJ9",
                "Drae",
                "David BBQ",
                "Schwifty Bud",
                "UI Pain",
                "Fe F2P",
                "WishengradHC",
                "n4ckerd",
                "Tohno1612",
                "H C Gilrix",
                "Frogmask",
                "NoQuestsHCIM",
                "Adentia",
                "threewaygang",
                "5perm sock",
                "Sir BoJo",
                "f2p Ello",
                "Ghost Bloke",
                "Fe Apes",
                "Iron of One",
                "InsurgentF2P",
                "cwismis noob",
                "Sad Jesus",
                "SapphireHam",
                "Doublessssss",
                "ColdFingers1",
                "xmymwf609",
                "Cas F2P HC",
                "Onnn",
                "Shade_Core",
                "Metan",
                "F2P UIM OREO",
                "Crawler",
                "UIM Dakota",
                "HCBown",
                "Dukeddd",
                "one a time",
                "Yewsless",
                "Wizards Foot",
                "F2P Jords",
                "a q p IM",
                "Hardcore VFL",
                "Pizzarrhea",
                "bemanisows",
                "Dusty Lime",
                "Brantrout",
                "f2p uim nerd",
                "Romans ch 12",
                "Feature",
                "Arizer Air",
                "Irondish",
                "Maze",
                "P1J",
                "Earfs",
                "the f2p uim",
                "ColdFingers3"]

  FAKES = ["laye btw", "supernovax9", "Alkie", "Da Jugg King", "F 2 P Jesus", "K4de", "Susen", "Turkish Bear", "YamiOscuro", "G-Jax", "A Level 73", "Mr Hakumo", "GeerdWilders", "Non-Skiller", "Diu", "Cyclostroith", "Flippencio", "Lxnch", "Gl No Arm", "Biostabil", "Candlebeard", "F2Prod", "Low Magic","Dpss Khz", "Joeeee", "2 Fiery 2613", "Plaffy", "Plop City", "Luumu", "Skeez N Flex", "Deoxys X", "Lil Skanks", "Deoxys Y", "Count Ragula", "Incipient11", "Vastn00b", "Ernestas", "Getido", "Akst0rm", "Gfyyjgfhjjfg", "Mycookingalt", "Antidzakar", "The Daddy De", "Angel Xx", "When 07", "Slabs986", "Kliiiiiiir", "Xzs", "Looorloorke", "Rs3hasailing", "Gybes729", "Schticks377", "Crunch42", "Luolaneekeri", "Brgn", "Cumcumber100", "Minijordan", "Gwyse", "Garof", "Spiderdreng4", "Ski Jump", "Rodaten", "Drequis", "Macho95", "Regretterd", "Dragons Lair", "Hai Yass", "Foolthiz", "Quincyx3", "Kortemark", "9 Dryad Cow", "Mmm Crabz", "Dailypoon25", "Smorc Champ", "Godlike", "Saap", "Ajshmayjay", "Dubstepn69", "Feeshone", "Orangemarmal", "Cfwx", "Luulul", "Tubracito", "Reclaimzed", "Xanthe Will", "Honesdale", "10hp Skill", "Xyujah1", "Vipc", "1212x", "Cybathug", "Afkallday", "Purcopyx", "Add1s0n", "Vulfepayne", "Airagan", "Cameronkuh", "Anne De Tank", "Psicowave", "CountStumpy2", "Mirnoi", "Riko661", "Gatormind", "Woodcutter7k", "Dopey Goat", "Uristmcdorf", "Boaswen", "Sirbloby123", "Del5thslave", "Minningguy14", "Del4thslave", "Aylaw", "0n Gp", "Venedi", "Yutram", "Whispah11", "Funkyjunk122", "Why You No", "Mrsshoarma", "Deathyy18", "Morthook", "Alexnolan", "Zem Fishies", "Bobfish66", "Hengen Mies", "Penguins 0", "Kingpin6999", "Minecat", "Greenholgart", "Ocigoniel", "Omgfreecake", "Vornollo", "Szzadi3", "Mistereremin", "Kawaiiniisan", "Thenthedr", "Redboyfrisco", "0t H", "Miner Timmie", "Takane", "Consortium", "Crisp Gains", "Mkbngg", "Mcgavin", "Orydel", "Porttieerik", "Mikeyman", "Azzazeell", "Zuls", "Purcopyxx", "Grand Danke", "Broembroemk", "Sir Kmilooxd", "Denise", "Puh3linmembu", "Salmonsmoker", "Recknded", "Justdontrush", "Hvvvppw", "Southernlady", "Onoesa", "Groovydroid", "Skiller0nlyy", "Mate Sauron", "Firem", "King Of Rr", "Kedaredan", "Umap", "Asku", "Aracion", "Ur Kiddin", "Muhpatriarky", "Bringing", "Amethyst Alt", "Gwilalian", "Minerio", "To Tank", "Etion Isces", "Flysandgold", "Adiput16", "Me Exp", "X O L337 O X", "Like Fire", "K S", "Zomble Boy", "Sinister Ug", "Mivok", "Chessy 018", "Pot Of Bone", "Alt Amethyst", "Ckzlphc", "Tko1", "Eat Baby Boy", "Jerayred", "Zjs", "Bank Nothing", "Iron Farter", "Dying Sea", "Xcrushyx", "Acigosh", "Sionoft", "Igsuck", "9 Only Low", "Apex Tigrex", "Lordnetto", "Anshelm", "Glardoldan", "Jayden 1486", "K1ss K1lla", "Lost Forest", "Lilypadda", "2002 Tii", "Conelle", "Resolution", "Sphdinp", "Araliclya", "Chanpluru", "Skillerzzzse", "Trigobard", "Raerey", "Tom Clancy", "Lolislay3r", "Emx", "Seek God", "Hagain", "Whatttattata",  "Dressing", "Blye", "Notoskillhop", "Unililith", "Hirawiel", "021805", "Lil Deyoung", "Albertxyx", "Pressing", "Strokinglogs", "Shark Fishr", "Del3rdslave", "Bangbung32", "Negnelfi", "30 Bag", "Tianyumi", "Mrwoodcut", "Dominics 1st", "Al Alt2", "06account", "Atipatio", "Snail4sale", "Bmatic 15", "Bgjela", "Vexens23", "W333seers Wc", "Isstoissr", "Goldwing100", "Steampress", "Flag1er", "Ezr3all", "Y3w5", "Whirlwind Ko"] 
  BANNED = ["F2Prod", "Sharply Stab", "Wachbirne", "Nanitronic", "Hc Tppk", "iron s4v4gez"]

  def self.included base
    base.send :include, InstanceMethods
    base.extend ClassMethods
  end

  def get_intervals
    INTERVALS
  end

  def self.supporters
    SUPPORTERS
  end
  
  def self.sql_supporters()
    quoted_names = SUPPORTERS.map{ |name| "'#{name}'" }
    "(#{quoted_names.join(",")})"
  end

  def get_fakes
    FAKES.map(&:downcase)
  end

  def self.get_banned
    BANNED
  end
  
  # The characters +, _, \s, -, %20 count as the same when doing a lookup on hiscores.
  def self.sanitize_name(str)
    if str.downcase == "_yrak"
      return str
    else
      str = str.gsub(/[-_\\+]|(%20)/, " ")
      return str.gsub(/\A[^A-z0-9]+|[^A-z0-9\s\_-]+|[^A-z0-9]+\z/, "")
    end
  end
  
  def self.find_player(id)
    id = self.sanitize_name(id)
    player = Player.where('lower(player_name) = ?', id.downcase).first
    if player.nil?
      name = id.gsub("_", " ")
      player = Player.where('lower(player_name) = ?', name.downcase).first
    end
    if player.nil?
      name = id.gsub(" ", "_")
      player = Player.where('lower(player_name) = ?', name.downcase).first
    end
    if player.nil?
      begin
        player = Player.find(Float(id))
      rescue
        return false
      end
    end
    return player
  end
  
  def check_hc_death
    if player_acc_type == "HCIM"
      begin
        im_uri = URI.parse("https://services.runescape.com/m=hiscore_oldschool_ironman/index_lite.ws?player=#{self.player_name}")
        im_stats = im_uri.read.split(" ")
        im_xp = im_stats[0].split(",")[2].to_f
        hc_uri = URI.parse("https://services.runescape.com/m=hiscore_oldschool_hardcore_ironman/index_lite.ws?player=#{self.player_name}")
        hc_stats = hc_uri.read.split(" ")
        hc_xp = hc_stats[0].split(",")[2].to_f
        if hc_xp < (im_xp - 1000000) or (im_xp - hc_xp).to_f/hc_xp > 0.05
          update_attribute(:player_acc_type, "IM")
        end
      rescue Exception => e   
        puts e.message 
      end
    end
  end
  
  def check_p2p(stats_hash)
    return stats_hash["potential_p2p"].to_f > 0
  end
  
  def remove_cutoff(stats_hash)
    if stats_hash["overall_ehp"] < 1
      Player.where(player_name: player_name).destroy_all
      return true
    end
  end
  
  def update_player
    if get_fakes.include?(player_name.downcase)
      Player.where(player_name: player_name).destroy_all
    end
    puts "updating #{player_name}"
    all_stats = get_stats(player_name, player_acc_type)
    if all_stats == false
      update_attributes(:potential_p2p => 1)
      return false
    end
    stats_hash = parse_raw_stats(all_stats)
    bonus_xp = calc_bonus_xps(stats_hash)
    stats_hash = calc_ehp(stats_hash)
    stats_hash = adjust_bonus_xp(stats_hash, bonus_xp)

    check_hc_death
    calc_combat(stats_hash)
    
    stats_hash["ttm_lvl"] = time_to_max(stats_hash, "lvl")
    stats_hash["ttm_xp"] = time_to_max(stats_hash, "xp")
    update_attributes(stats_hash)
    
    if stats_hash["overall_ehp"] > 250 or Player.supporters.include?(player_name)
      get_intervals.each do |time|
        xp = self.read_attribute("overall_xp_#{time}_start")
        if xp.nil? or xp == 0
          update_player_start_stats(time)
        end
      end
      
      check_record_gains
    end
  end
  
  def check_record_gains
    get_skills.each do |skill|
      xp = self.read_attribute("#{skill}_xp")
      ehp = self.read_attribute("#{skill}_ehp")
      get_intervals.each do |time|
        start_xp = self.read_attribute("#{skill}_xp_#{time}_start")
        start_ehp = self.read_attribute("#{skill}_ehp_#{time}_start")
        max_xp = self.read_attribute("#{skill}_xp_#{time}_max")
        max_ehp = self.read_attribute("#{skill}_ehp_#{time}_max")
        if start_xp.nil? or start_ehp.nil?
          next
        end
        if max_xp.nil? or xp - start_xp > max_xp
          update_attributes("#{skill}_xp_#{time}_max" => xp - start_xp)
        end
        if max_ehp.nil? or ehp - start_ehp > max_ehp
          update_attributes("#{skill}_ehp_#{time}_max" => ehp - start_ehp)
        end
      end
    end
  end
  
  def update_player_start_stats(time)
    get_skills.each do |skill|
      xp = self.read_attribute("#{skill}_xp")
      ehp = self.read_attribute("#{skill}_ehp")
      update_attributes("#{skill}_xp_#{time}_start" => xp)
      update_attributes("#{skill}_ehp_#{time}_start" => ehp)
    end
  end
  
  def repair_tracking(time)
    xp_start, ehp_start = get_repaired_tracking(player_acc_type, time)

    update_attributes(xp_start.merge(ehp_start))
  end
  
  def repair_records
    recs = get_repaired_records(player_name, player_acc_type)
    unless recs
      return
    end
    
    update_attributes(recs_hash)
  end

  def recalculate_ehp
    skill_hash = get_recalculated_ehp(player_acc_type)
    update_attributes(skill_hash)
  end
  
  def self.acc_type_xp(name, acc_type)
    stats = get_stats(name, acc_type)
    return 0 if not stats
    return stats[0].split(",")[2].to_f
  end
  
  def self.determine_acc_type(name)
    uim_xp = self.acc_type_xp(name, "UIM")
    hcim_xp = self.acc_type_xp(name, "HCIM")
    im_xp = self.acc_type_xp(name, "IM")
    reg_xp = self.acc_type_xp(name, "Reg")
    if uim_xp > 0 and uim_xp >= reg_xp and uim_xp >= im_xp
      return "UIM"
    elsif hcim_xp > 0 and hcim_xp >= reg_xp and hcim_xp >= im_xp
      return "HCIM"
    elsif im_xp > 0 and im_xp >= reg_xp
      return "IM"
    elsif reg_xp > 0 
      return "Reg"
    else
      return nil
      # raise "Account type cannot be determined."
    end
  end

  def self.check_p2p(stats)
    return stats["potential_p2p"] > 0
  end

  def self.create_new(name)  
    name = self.sanitize_name(name)
    found = self.find_player(name)
    if found
      return "exists"
    elsif get_fakes.include?(name.downcase)
      return "p2p"
    end

    acc_type = self.determine_acc_type(name)
    if acc_type.nil?
      return nil
    end

    stats = get_stats(name, acc_type)
    stats = parse_raw_stats(stats)
    
    if self.check_p2p(stats)
      return "p2p"
    end

    Player.create!({"player_name" => name, "player_acc_type" => acc_type})
    player = Player.find_player(name)
    result = player.update_player
    return player
  end
end
