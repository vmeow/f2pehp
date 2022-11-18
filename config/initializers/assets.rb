# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path
F2POSRSRanks::Application.configure do
    config.version = "F2P Wiki v1.13"

   config.fakes = ["Zezrian", "plusle", "Food Heater", "FakingF2P", "laye btw", "supernovax9", "Alkie", "Da Jugg King", "F 2 P Jesus", "K4de", "Susen", "Turkish Bear", "YamiOscuro", "G-Jax", "A Level 73", "Mr Hakumo", "GeerdWilders", "Non-Skiller", "Sqwrt", "Diu", "Cyclostroith", "Flippencio", "Lxnch", "Gl No Arm", "Biostabil", "Candlebeard", "F2Prod", "Low Magic","Dpss Khz", "Joeeee", "2 Fiery 2613", "Plaffy", "Plop City", "Luumu", "Skeez N Flex", "Deoxys X", "Lil Skanks", "Deoxys Y", "Count Ragula", "Incipient11", "Vastn00b", "Ernestas", "Getido", "Akst0rm", "Gfyyjgfhjjfg", "Mycookingalt", "Antidzakar", "The Daddy De", "Angel Xx", "When 07", "Slabs986", "Kliiiiiiir", "Xzs", "Looorloorke", "Rs3hasailing", "Gybes729", "Schticks377", "Crunch42", "Luolaneekeri", "Brgn", "Cumcumber100", "Minijordan", "Gwyse", "Garof", "Spiderdreng4", "Ski Jump", "Rodaten", "Drequis", "Macho95", "Regretterd", "Dragons Lair", "Hai Yass", "Foolthiz", "Quincyx3", "Kortemark", "9 Dryad Cow", "Mmm Crabz", "Dailypoon25", "Smorc Champ", "Godlike", "Saap", "Ajshmayjay", "Dubstepn69", "Feeshone", "Orangemarmal", "Cfwx", "Luulul", "Tubracito", "Reclaimzed", "Xanthe Will", "Honesdale", "10hp Skill", "Xyujah1", "Vipc", "1212x", "Cybathug", "Afkallday", "Purcopyx", "Add1s0n", "Vulfepayne", "Airagan", "Cameronkuh", "Anne De Tank", "Psicowave", "CountStumpy2", "Mirnoi", "Riko661", "Gatormind", "Woodcutter7k", "Dopey Goat", "Uristmcdorf", "Boaswen", "Sirbloby123", "Del5thslave", "Minningguy14", "Del4thslave", "Aylaw", "0n Gp", "Venedi", "Yutram", "Whispah11", "Funkyjunk122", "Why You No", "Mrsshoarma", "Deathyy18", "Morthook", "Alexnolan", "Zem Fishies", "Bobfish66", "Hengen Mies", "Penguins 0", "Kingpin6999", "Minecat", "Greenholgart", "Ocigoniel", "Omgfreecake", "Vornollo", "Szzadi3", "Mistereremin", "Kawaiiniisan", "Thenthedr", "Redboyfrisco", "0t H", "Miner Timmie", "Takane", "Consortium", "Crisp Gains", "Mkbngg", "Mcgavin", "Orydel", "Porttieerik", "Mikeyman", "Azzazeell", "Zuls", "Purcopyxx", "Grand Danke", "Broembroemk", "Sir Kmilooxd", "Denise", "Puh3linmembu", "Salmonsmoker", "Recknded", "Justdontrush", "Hvvvppw", "Southernlady", "Onoesa", "Groovydroid", "Skiller0nlyy", "Mate Sauron", "Firem", "King Of Rr", "Kedaredan", "Umap", "Asku", "Aracion", "Ur Kiddin", "Muhpatriarky", "Bringing", "Amethyst Alt", "Gwilalian", "Minerio", "To Tank", "Etion Isces", "Flysandgold", "Adiput16", "Me Exp", "X O L337 O X", "Like Fire", "K S", "Zomble Boy", "Sinister Ug", "Mivok", "Chessy 018", "Pot Of Bone", "Alt Amethyst", "Ckzlphc", "Tko1", "Eat Baby Boy", "Jerayred", "Zjs", "Bank Nothing", "Iron Farter", "Dying Sea", "Xcrushyx", "Acigosh", "Sionoft", "Igsuck", "9 Only Low", "Apex Tigrex", "Lordnetto", "Anshelm", "Glardoldan", "Jayden 1486", "K1ss K1lla", "Lost Forest", "Lilypadda", "2002 Tii", "Conelle", "Resolution", "Sphdinp", "Araliclya", "Chanpluru", "Skillerzzzse", "Trigobard", "Raerey", "Tom Clancy", "Lolislay3r", "Emx", "Seek God", "Hagain", "Whatttattata",  "Dressing", "Blye", "Notoskillhop", "Unililith", "Hirawiel", "021805", "Lil Deyoung", "Albertxyx", "Pressing", "Strokinglogs", "Shark Fishr", "Del3rdslave", "Bangbung32", "Negnelfi", "30 Bag", "Tianyumi", "Mrwoodcut", "Dominics 1st", "Al Alt2", "06account", "Atipatio", "Snail4sale", "Bmatic 15", "Bgjela", "Vexens23", "W333seers Wc", "Isstoissr", "Goldwing100", "Steampress", "Flag1er", "Ezr3all", "Y3w5", "Whirlwind Ko", "Non Skiller", "prayer guy", "Sepp142013", "StraightF2P", "Iron Turael", "Palaadium", "Itubio", "Fishmadnes91", "BlackCountre", "F2P Trust", "Fordly", "Marchlands", "WhoseNotF2p", "cool3113cool", "Canadian Dee", "firebirdxvi", "Starminerf2p", "xaldazar"]
   config.downcase_fakes = config.fakes.map(&:downcase)
   config.banned = ["F2Prod", "Sharply Stab", "Wachbirne", "Nanitronic", "Hc Tppk", "iron s4v4gez", "Mr J Valeska", "atwilburn92"]
   config.downcase_banned = config.banned.map(&:downcase)

    #ORDER OF SKILLS ON http://services.runescape.com/m=hiscore_oldschool/index_lite.ws?player=NAME
    config.skills = ["overall",
                     "attack",
                     "defence",
                     "strength",
                     "hitpoints",
                     "ranged",
                     "prayer",
                     "magic",
                     "cooking",
                     "woodcutting",
                     "p2p",
                     "fishing",
                     "firemaking",
                     "crafting",
                     "smithing",
                     "mining",
                     "p2p",
                     "p2p",
                     "p2p",
                     "p2p",
                     "p2p",
                     "runecraft",
                     "p2p",
                     "p2p",
                     "p2p_minigame",
                     "p2p_minigame",
                     "p2p_minigame",
                     "clues_all",
                     "clues_beginner",
                     "p2p_minigame",
                     "p2p_minigame",
                     "p2p_minigame",
                     "p2p_minigame",
                     "p2p_minigame",
                     "lms",
                     "p2p_minigame", # somewhere around here pvp arena added here fuck you jagex 2022-07-13
                     "p2p_minigame",
                     "p2p_minigame",
                     "p2p_minigame", #rifts closed 13-04-2022
                     "p2p_minigame",
                     "p2p_minigame",
                     "bryophyta_kc",
                     "p2p_minigame",
                     "p2p_minigame",
                     "p2p_minigame",
                     "p2p_minigame",
                     "p2p_minigame",
                     "p2p_minigame",
                     "p2p_minigame",
                     "p2p_minigame",
                     "p2p_minigame",
                     "p2p_minigame",
                     "p2p_minigame",
                     "p2p_minigame",
                     "p2p_minigame",
                     "p2p_minigame",
                     "p2p_minigame",
                     "p2p_minigame",
                     "p2p_minigame",
                     "p2p_minigame",
                     "p2p_minigame",
                     "p2p_minigame",
                     "p2p_minigame",
                     "p2p_minigame",
                     "p2p_minigame",
                     "p2p_minigame",
                     "p2p_minigame", # phosani's nightmare new on 2021-06-30, fuck you jagex
                     "p2p_minigame", # nex 2021-01-05
                     "obor_kc",
                     "p2p_minigame",
                     "p2p_minigame",
                     "p2p_minigame",
                     "p2p_minigame",
                     "p2p_minigame",
                     "p2p_minigame",
                     "p2p_minigame",
                     "p2p_minigame",
                     "p2p_minigame",
                     "p2p_minigame",
                     "p2p_minigame",
                     "p2p_minigame",
                     "p2p_minigame",
                     "p2p_minigame",
                     "p2p_minigame",
                     "p2p_minigame"
                 ]
    
    config.f2p_skills = ["attack", "strength", "defence", "hitpoints", "ranged", "prayer",
                         "magic", "cooking", "woodcutting", "fishing", "firemaking", "crafting",
                         "smithing", "mining", "runecraft"]
                         
    config.xp_table = [0, 83, 174, 276, 388, 512, 650, 801, 969, 
        1154, 1358, 1584, 1833, 2107, 2411, 2746, 3115, 3523, 3973, 
        4470, 5018, 5624, 6291, 7028, 7842, 8740, 9730, 10824, 12031, 
        13363, 14833, 16456, 18247, 20224, 22406, 24815, 27473, 30408, 33648, 
        37224, 41171, 45529, 50339, 55649, 61512, 67983, 75127, 83014, 91721, 
        101333, 111945, 123660, 136594, 150872, 166636, 184040, 203254, 224466, 247886, 
        273742, 302288, 333804, 368599, 407015, 449428, 496254, 547953, 605032, 668051, 
        737627, 814445, 899257, 992895, 1096278, 1210421, 1336443, 1475581, 1629200, 1798808, 
        1986068, 2192818, 2421087, 2673114, 2951373, 3258594, 3597792, 3972294, 4385776, 4842295, 
        5346332, 5902831, 6517253, 71954629, 7944614, 8771558, 9684577, 10692629, 11805606, 13034431]

    config.lvl_tiers = [32, 45, 60, 75, 90, 105, 120, 135, 150, 165, 
        180, 195, 210, 225, 240, 255, 270, 285, 300, 315, 
        330, 345, 360, 375, 390, 405, 420, 435, 450, 465, 
        480, 495, 510, 525, 540, 555, 570, 585, 600, 615, 
        630, 645, 660, 675, 690, 705, 720, 735, 750, 765, 
        780, 795, 810, 825, 840, 855, 870, 885, 900, 915, 
        930, 945, 960, 975, 990, 1005, 1020, 1035, 1050, 1065, 
        1080, 1095, 1110, 1125, 1140, 1155, 1170, 1185, 1200, 1215, 
        1230, 1245, 1260, 1275, 1290, 1305, 1320, 1335, 1350, 1365, 
        1380, 1395, 1410, 1425, 1440, 1455, 1470, 1485]
    
    config.lvl_xps = [166, 522, 1104, 1940, 3072, 4550, 6408, 8721, 11540, 14938, 
        19008, 23829, 29498, 36165, 43936, 52955, 63414, 75487, 89400, 105378, 
        123728, 144693, 168672, 196050, 227240, 262710, 303072, 348899, 400890, 459823, 
        526592, 602151, 687616, 784210, 893340, 1016501, 1155504, 1312272, 1488960, 1688011, 
        1912218, 2164577, 2448556, 2768040, 3127218, 3530969, 3984672, 4494329, 5066650, 5709195, 
        6430320, 7239482, 8147088, 9164980, 10306240, 11585478, 13019028, 14625274, 16424520, 18439568,
        20695848, 23221737, 26048960, 29212820, 32752764, 36712851, 41142176, 46095519, 51633890, 57825595, 
        64746504, 72481335, 81124572, 90781575, 101569668, 113619737, 127077600, 142105832, 158885440, 177618258, 
        198529134, 221868462, 247915332, 276980490, 309410112, 345589578, 385948288, 430964255, 481169880, 537157621, 
        599587276, 6691780497, 746793716, 833298010, 929719392, 1037185013, 1156949388, 1290408669]

    config.ehp_reg = Hash.new
    config.ehp_iron = Hash.new
    config.ehp_uim = Hash.new
    
    config.ehp_reg['attack_method'] = "1 defence castle wars alts, after 40 attack it assumes you will train to 99 str first"
    config.ehp_reg['attack_method_video'] = "https://www.youtube.com/watch?v=xY_Ej74Muz8";
    config.ehp_reg['strength_method'] = "1 defence castle wars alts"
    config.ehp_reg['strength_method_video'] = "https://www.youtube.com/watch?v=xY_Ej74Muz8";
    config.ehp_reg['defence_method'] = "1 defence castle wars alts after 99 att/str"
    config.ehp_reg['defence_method_video'] = "https://www.youtube.com/watch?v=xY_Ej74Muz8";
    config.ehp_reg['ranged_method'] = "1 defence castle wars alts"
    config.ehp_reg['ranged_method_video'] = "https://www.youtube.com/watch?v=xY_Ej74Muz8";
    config.ehp_reg['hitpoints_method'] = "0 time during combats"
    config.ehp_reg['prayer_method'] = "Scatter-bury (some 0-time during other skills)"
    config.ehp_reg['prayer_method_video'] = "https://www.youtube.com/watch?v=0eJU_ED3tkE";
    config.ehp_reg['magic_method'] = "Best spell, low alch, superheat, alch + fally tele + fire blast, then alch + teleblock (some 0-time during other skills)"
    config.ehp_reg['magic_method_video'] = "https://i.imgur.com/UTMN13p.gif";
    config.ehp_reg['cooking_method'] = "1-tick beef then wines"
    config.ehp_reg['cooking_method_video'] = "https://www.youtube.com/watch?v=KCXXLQi5i-8";
    config.ehp_reg['woodcutting_method'] = "4-tick trees, then 2-tick oaks while alching"
    config.ehp_reg['woodcutting_method_video'] = "https://www.youtube.com/watch?v=CNvCUzFNkCg";
    config.ehp_reg['fishing_method'] = "Best fish, then 3-tick snow and leather fly fishing"
    config.ehp_reg['fishing_method_video'] = "https://www.youtube.com/watch?v=lPcuhfQlOGs";
    config.ehp_reg['firemaking_method'] = "Best logs, with 0-time prayer"
    config.ehp_reg['firemaking_method_video'] = "https://www.youtube.com/watch?v=97ABCow8Xys";
    config.ehp_reg['crafting_method'] = "Best leather item, then best gem"
    config.ehp_reg['crafting_method_video'] = "https://www.youtube.com/watch?v=QyKlFC6sabE"
    config.ehp_reg['smithing_method'] = "Best platebody until adamant platebody, with alts to trade"
    config.ehp_reg['smithing_method_video'] = "https://www.youtube.com/watch?v=zYLfUIkqFw4"
    config.ehp_reg['mining_method'] = "Best rock until iron, 3-tick cake iron at Mining guild while scattering ashes"
    config.ehp_reg['mining_method_video'] = "https://www.youtube.com/watch?v=0aV7A1E7eOE"
    config.ehp_reg['runecraft_method'] = "Solo body talismans"
    config.ehp_reg['runecraft_method_video'] = "https://www.youtube.com/watch?v=zEL1JO-uYKU"
    
    config.ehp_iron['attack_method'] = "1-40 questing xp and cows, 40-99 hill giants, 99+ ogresses and hill giants (all with prayer flicking)"
    config.ehp_iron['attack_method_video'] = "https://youtu.be/IxYY0Viem-w"
    config.ehp_iron['strength_method'] = "1-40 questing xp and cows, 40-99 hill giants, 99+ ogresses and hill giants (all with prayer flicking)"
    config.ehp_iron['strength_method_video'] = "https://youtu.be/IxYY0Viem-w"
    config.ehp_iron['defence_method'] = "1-40 questing xp and cows, 40-99+ ogresses and hill giants (all with prayer flicking)"
    config.ehp_iron['defence_method_video'] = "https://youtu.be/IxYY0Viem-w"
    config.ehp_iron['ranged_method'] = "1-40 minotaurs, 40-50 hill giants, 50-99 ogresses, 99+ ogresses and obor (all with pray flicking, using best arrows)"
    config.ehp_iron['ranged_method_video'] = "https://www.youtube.com/watch?v=o6_Iw67RVbE"
    config.ehp_iron['hitpoints_method'] = "0 time during combats"
    config.ehp_iron['prayer_method'] = "Double hop boneyard and 0-time big bones from giants/ogresses"
    config.ehp_iron['prayer_method_video'] = "https://www.youtube.com/watch?v=yikJBIhriH4"
    config.ehp_iron['magic_method'] = "0-time teleport/superheat/telegrab/high alch during other skills"
    config.ehp_iron['cooking_method'] = "Shrimp, sardines and herring, then trout/salmon 0-tick while fishing (erie fish)"
    config.ehp_iron['cooking_method_video'] = "https://www.youtube.com/watch?v=21CYgZBqoVk"
    config.ehp_iron['woodcutting_method'] = "4-tick normal trees, 3-tick oak trees, 2.66-tick willow trees, also train alongside runecrafting"
    config.ehp_iron['woodcutting_method_video'] = "https://www.youtube.com/watch?v=VbeN6_X2qKI"
    config.ehp_iron['fishing_method'] = "Shrimp, sardines and herring, then trout/salmon 3-ticked with snow/cooked fish (erie fish)"
    config.ehp_iron['fishing_method_video'] = "https://www.youtube.com/watch?v=8m0hV8KtTYs"
    config.ehp_iron['firemaking_method'] = "Logs, oak logs, then willow logs, during woodcutting"
    config.ehp_iron['firemaking_method_video'] = "https://www.youtube.com/watch?v=VbeN6_X2qKI"
    config.ehp_iron['crafting_method'] = "Leather, then double hop Varrock SW chronicle teleport tiaras with tick manip and 0 time gems from ogresses"
    config.ehp_iron['crafting_method_video'] = "https://www.youtube.com/watch?v=8m0hV8KtTYs"
    config.ehp_iron['smithing_method'] = "Knight's sword, superheat iron with snow after double hop telegrabbing wildy nats, 0-time silver smelting"
    config.ehp_iron['smithing_method_video'] = "https://www.youtube.com/watch?v=7JuJjTjx_bE"
    config.ehp_iron['mining_method'] = "0 time during crafting, smithing, runecraft"
    config.ehp_iron['runecraft_method'] = "Ess mine to earth runes with chronicle tele, training woodcutting alongside"
    config.ehp_iron['runecraft_method_video'] = "https://www.youtube.com/watch?v=uJsL3jN_gD8"
    
    config.ehp_uim['attack_method'] = "1-40 questing xp and cows, 40-99 hill giants, 99+ ogresses and hill giants (all with prayer flicking)"
    config.ehp_uim['attack_method_video'] = "https://youtu.be/IxYY0Viem-w"
    config.ehp_uim['strength_method'] = "1-40 questing xp and cows, 40-99 hill giants, 99+ ogresses and hill giants (all with prayer flicking)"
    config.ehp_uim['strength_method_video'] = "https://youtu.be/IxYY0Viem-w"
    config.ehp_uim['defence_method'] = "1-40 questing xp and cows, 40-99+ ogresses and hill giants (all with prayer flicking)"
    config.ehp_uim['defence_method_video'] = "https://youtu.be/IxYY0Viem-w"
    config.ehp_uim['ranged_method'] = "1-40 minotaurs, 40-50 hill giants, 50-99 ogresses, 99+ ogresses and obor (all with pray flicking, using best arrows)"
    config.ehp_uim['ranged_method_video'] = "https://www.youtube.com/watch?v=o6_Iw67RVbE"
    config.ehp_uim['hitpoints_method'] = "0 time during combats"
    config.ehp_uim['prayer_method'] = "Double hop boneyard and 0-time big bones from giants/ogresses"
    config.ehp_uim['prayer_method_video'] = "https://www.youtube.com/watch?v=yikJBIhriH4"
    config.ehp_uim['magic_method'] = "0-time teleport/superheat/telegrab/high alch during other skills"
    config.ehp_uim['cooking_method'] = "Shrimp, sardines and herring, then trout/salmon 0-tick while fishing (erie fish)"
    config.ehp_uim['cooking_method_video'] = "https://www.youtube.com/watch?v=8m0hV8KtTYs"
    config.ehp_uim['woodcutting_method'] = "4-tick normal trees, 3-tick oak trees, 2.66-tick willow trees, also train alongside runecrafting"
    config.ehp_uim['woodcutting_method_video'] = "https://www.youtube.com/watch?v=VbeN6_X2qKI"
    config.ehp_uim['fishing_method'] = "Shrimp, sardines and herring, then trout/salmon 3-ticked with snow/cooked fish (erie fish)"
    config.ehp_uim['fishing_method_video'] = "https://www.youtube.com/watch?v=8m0hV8KtTYs"
    config.ehp_uim['firemaking_method'] = "Logs, oak logs, then willow logs, during woodcutting"
    config.ehp_uim['firemaking_method_video'] = "https://www.youtube.com/watch?v=VbeN6_X2qKI"
    config.ehp_uim['crafting_method'] = "Leather, then double hop Varrock SW chronicle teleport tiaras with tick manip and 0 time gems from ogresses"
    config.ehp_uim['crafting_method_video'] = "https://www.youtube.com/watch?v=txoHCe8Jplk"
    config.ehp_uim['smithing_method'] = "Knight's sword, superheat iron with snow after double hop telegrabbing wildy nats, 0-time silver smelting"
    config.ehp_uim['smithing_method_video'] = "https://www.youtube.com/watch?v=7JuJjTjx_bE"
    config.ehp_uim['mining_method'] = "0 time during crafting, smithing, runecraft"
    config.ehp_uim['runecraft_method'] = "Ess mine to earth runes with chronicle tele, training woodcutting alongside"
    config.ehp_uim['runecraft_method_video'] = "https://www.youtube.com/watch?v=uJsL3jN_gD8"
  
    # config.ehp_reg['attack_tiers'] = [0, 37224, 100000, 1000000, 1986068, 3000000, 5346332, 13034431]
    # config.ehp_reg['attack_xphrs'] = [5300, 25450, 29500, 37900, 44800, 46900, 50800, 53500]
  
    # config.ehp_reg['strength_tiers'] = [0, 37224, 100000, 1000000, 1986068, 3000000, 5346332, 13034431]
    # config.ehp_reg['strength_xphrs'] = [5300, 25450, 29500, 37900, 44800, 46900, 50800, 53500]
  
    # config.ehp_reg['defence_tiers'] = [0, 37224, 100000, 1000000, 1986068, 3000000, 5346332, 13034431]
    # config.ehp_reg['defence_xphrs'] = [5300, 25450, 29500, 37900, 44800, 46900, 50800, 53500]
  
    # config.ehp_reg['hitpoints_tiers'] = [0]
    # config.ehp_reg['hitpoints_xphrs'] = [0]
  
    # config.ehp_reg['ranged_tiers'] = [0, 37224, 100000, 1000000, 1986068, 3000000, 5346332, 13034431]
    # config.ehp_reg['ranged_xphrs'] = [4900, 24650, 30500, 44800, 45900, 46100, 49200, 55000]
    config.ehp_reg['attack_tiers'] = [0, 37224]
    config.ehp_reg['attack_xphrs'] = [8000, 90000]
  
    config.ehp_reg['strength_tiers'] = [0, 37224, 50339, 75127, 123660, 166636, 273742, 407015, 547953, 899257, 1336443, 1986068, 2951373, 4385776, 7195629, 9684577]
    config.ehp_reg['strength_xphrs'] = [8000, 40500, 43500, 49000, 52000, 55000, 58000, 61000, 66500, 69500, 72500, 75500, 78500, 84000, 87000, 90000]
  
    config.ehp_reg['defence_tiers'] = [0]
    config.ehp_reg['defence_xphrs'] = [90000]
  
    config.ehp_reg['hitpoints_tiers'] = [0]
    config.ehp_reg['hitpoints_xphrs'] = [0]
  
    config.ehp_reg['ranged_tiers'] = [0, 13363, 20224, 33648, 55649, 91721, 150872, 273742, 449428, 737627, 1210421, 1986068, 3258594, 5346332, 8771558, 13034431]
    config.ehp_reg['ranged_xphrs'] = [8000, 30000, 34000, 40500, 44500, 48500, 52500, 56500, 63000, 66500, 70500, 74500, 78500, 85500, 89500, 90000]
  
    config.ehp_reg['prayer_tiers'] = [0]
    config.ehp_reg['prayer_xphrs'] = [105000]
  
    config.ehp_reg['magic_tiers'] = [0, 5018, 50339, 166636, 3258594]
    config.ehp_reg['magic_xphrs'] = [15000, 60000, 100000, 165000, 180000]
  
    config.ehp_reg['cooking_tiers'] = [0, 22406, 605032]
    config.ehp_reg['cooking_xphrs'] = [100000, 450000, 480000]
  
    config.ehp_reg['woodcutting_tiers'] = [0, 5018, 14833, 41171, 101333, 302288]
    config.ehp_reg['woodcutting_xphrs'] = [29500, 40000, 55500, 73500, 81500, 90000]
  
    config.ehp_reg['fishing_tiers'] = [0, 4470, 13363, 101333, 273742, 73627, 1986068, 5902831, 8771558, 13034431]
    config.ehp_reg['fishing_xphrs'] = [14000, 28000, 40000, 55500, 61500, 68000, 74250, 79750, 82500, 90000]

    config.ehp_reg['firemaking_tiers'] = [0, 13363, 61512, 273742]
    config.ehp_reg['firemaking_xphrs'] = [45000, 132660, 198990, 298485]
  
    config.ehp_reg['crafting_tiers'] = [0, 4470, 9730, 20224, 50339]
    config.ehp_reg['crafting_xphrs'] = [37000, 137200, 185220, 233240, 290000]
  
    # config.ehp_reg['smithing_tiers'] = [0, 37224, 605032, 4385776, 170000000]
    # config.ehp_reg['smithing_xphrs'] = [40000, 129000, 200000, 250000, 30000000]
    
    # config.ehp_reg['mining_tiers'] = [0, 14833, 41171, 111945] 
    # config.ehp_reg['mining_xphrs'] = [4000, 12000, 25000, 57000]
  
    # config.ehp_reg['runecraft_tiers'] = [0]
    # config.ehp_reg['runecraft_xphrs'] = [26000]
    config.ehp_reg['smithing_tiers'] = [0, 12725, 18247, 83014, 605032, 4385776]
    config.ehp_reg['smithing_xphrs'] = [12725, 58000, 116000, 174000, 232000, 290000]
  
    config.ehp_reg['mining_tiers'] = [0, 2411, 5018, 14833, 41171, 302288]
    config.ehp_reg['mining_xphrs'] = [4000, 46250, 49000, 52500, 55000, 57000]
  
    config.ehp_reg['runecraft_tiers'] = [0]
    config.ehp_reg['runecraft_xphrs'] = [55000]
  
  
  
    config.ehp_iron['attack_tiers'] = [0, 37224, 101333, 273742, 737627, 1210421, 1629200, 2192818, 3258594, 3972294, 5346332, 7944614, 13034431]
    config.ehp_iron['attack_xphrs'] = [5000, 41100, 46400, 47600, 48400, 48800, 49000, 49200, 49400, 49500, 49650, 49850, 49000]
  
    config.ehp_iron['strength_tiers'] = [0, 37224, 101333, 273742, 737627, 1210421, 1629200, 2192818, 3258594, 3972294, 5346332, 7944614, 11805606, 13034431] 
    config.ehp_iron['strength_xphrs'] = [5000, 24900, 28400, 33000, 36500, 37500, 38900, 40450, 41900, 42900, 44200, 45900, 49900, 49800]
  
    config.ehp_iron['defence_tiers'] = [0, 37224]
    config.ehp_iron['defence_xphrs'] = [5000, 49500]
  
    config.ehp_iron['hitpoints_tiers'] = [0]
    config.ehp_iron['hitpoints_xphrs'] = [0]
  
    config.ehp_iron['ranged_tiers'] = [0, 37224, 101333, 184040, 273742, 368599, 547953, 737627, 992895, 1475581, 1986068, 2673114, 3972294, 5346332, 7944614, 10692629, 13034431] 
    config.ehp_iron['ranged_xphrs'] = [4000, 22850, 19950, 23450, 24400, 27050, 30100, 30550, 33250, 34000, 36900, 37300, 40300, 40650, 43400, 46350, 45100]
  
    config.ehp_iron['prayer_tiers'] = [0]
    config.ehp_iron['prayer_xphrs'] = [14000]
  
    # config.ehp_iron['magic_tiers'] = [0, 3973, 247886, 3500000, 13034000, 53700000]
    # config.ehp_iron['magic_xphrs'] = [5000, 34800, 51700, 9534000, 51700, 146300000]
  
    config.ehp_iron['magic_tiers'] = [0]
    config.ehp_iron['magic_xphrs'] = [0]
  
    # config.ehp_iron['cooking_tiers'] = [0, 101333]
    # config.ehp_iron['cooking_xphrs'] = [40000, 120000]
  
    config.ehp_iron['cooking_tiers'] = [0]
    config.ehp_iron['cooking_xphrs'] = [2052000]

    config.ehp_iron['woodcutting_tiers'] = [0, 2411, 13363, 41171, 302288, 1986068, 5346332, 13034431]
    config.ehp_iron['woodcutting_xphrs'] = [8365, 17894, 35450, 50500, 63150, 76000, 88650, 95000]
  
    # config.ehp_iron['fishing_tiers'] = [0, 4470, 13363, 273742, 737627, 2500000, 6000000, 13034431, 149000000]
    # config.ehp_iron['fishing_xphrs'] = [14000, 28000, 35000, 45000, 55000, 65000, 70000, 75000, 78500]
  
    config.ehp_iron['fishing_tiers'] = [0, 4470, 13363, 273742, 737627, 2421087, 5902831, 13034431]
    config.ehp_iron['fishing_xphrs'] = [14000, 28000, 35250, 60350, 71000, 76250, 81000, 90000]
  
    # config.ehp_iron['firemaking_tiers'] = [0, 3858, 21381, 101333]
    # config.ehp_iron['firemaking_xphrs'] = [30700, 46100, 69100, 144600]
  
    config.ehp_iron['firemaking_tiers'] = [0, 13363]
    config.ehp_iron['firemaking_xphrs'] = [45000, 130500]
  
    config.ehp_iron['crafting_tiers'] = [0]
    config.ehp_iron['crafting_xphrs'] = [20000]
  
    # config.ehp_iron['smithing_tiers'] = [0, 10050000, 13034000, 154200000]
    # config.ehp_iron['smithing_xphrs'] = [8950, 2984000, 8950, 45800000]
  
    config.ehp_iron['smithing_tiers'] = [0]
    config.ehp_iron['smithing_xphrs'] = [22700]
  
    config.ehp_iron['mining_tiers'] = [0]
    config.ehp_iron['mining_xphrs'] = [0]
  
    config.ehp_iron['runecraft_tiers'] = [0]
    config.ehp_iron['runecraft_xphrs'] = [4650]
  
  
  
    config.ehp_uim['attack_tiers'] = [0, 37224, 101333, 273742, 737627, 1210421, 1629200, 2192818, 3258594, 3972294, 5346332, 7944614, 13034431]
    config.ehp_uim['attack_xphrs'] = [5000, 41100, 46400, 47600, 48400, 48800, 49000, 49200, 49400, 49500, 49650, 49850, 49000]
  
    config.ehp_uim['strength_tiers'] = [0, 37224, 101333, 273742, 737627, 1210421, 1629200, 2192818, 3258594, 3972294, 5346332, 7944614, 11805606, 13034431] 
    config.ehp_uim['strength_xphrs'] = [5000, 24900, 28400, 33000, 36500, 37500, 38900, 40450, 41900, 42900, 44200, 45900, 49900, 49800]
  
    config.ehp_uim['defence_tiers'] = [0, 37224]
    config.ehp_uim['defence_xphrs'] = [5000, 49500]
  
    config.ehp_uim['hitpoints_tiers'] = [0]
    config.ehp_uim['hitpoints_xphrs'] = [0]
  
    config.ehp_uim['ranged_tiers'] = [0, 37224, 101333, 184040, 273742, 368599, 547953, 737627, 992895, 1475581, 1986068, 2673114, 3972294, 5346332, 7944614, 10692629, 13034431] 
    config.ehp_uim['ranged_xphrs'] = [4000, 22850, 19950, 23450, 24400, 27050, 30100, 30550, 33250, 34000, 36900, 37300, 40300, 40650, 43400, 46350, 45100]
  
    config.ehp_uim['prayer_tiers'] = [0]
    config.ehp_uim['prayer_xphrs'] = [14000]
  
    # config.ehp_uim['magic_tiers'] = [0, 3973, 247886, 3500000, 13034000, 53700000]
    # config.ehp_uim['magic_xphrs'] = [5000, 34800, 51700, 9534000, 51700, 146300000]
  
    config.ehp_uim['magic_tiers'] = [0]
    config.ehp_uim['magic_xphrs'] = [0]
  
    # config.ehp_uim['cooking_tiers'] = [0, 101333]
    # config.ehp_uim['cooking_xphrs'] = [40000, 120000]
  
    config.ehp_uim['cooking_tiers'] = [0]
    config.ehp_uim['cooking_xphrs'] = [2052000]

    config.ehp_uim['woodcutting_tiers'] = [0, 2411, 13363, 41171, 302288, 1986068, 5346332, 13034431]
    config.ehp_uim['woodcutting_xphrs'] = [8365, 17894, 35450, 50500, 63150, 76000, 88650, 95000]
  
    # config.ehp_uim['fishing_tiers'] = [0, 4470, 13363, 273742, 737627, 2500000, 6000000, 13034431, 149000000]
    # config.ehp_uim['fishing_xphrs'] = [14000, 28000, 35000, 45000, 55000, 65000, 70000, 75000, 78500]
  
    config.ehp_uim['fishing_tiers'] = [0, 4470, 13363, 273742, 737627, 2421087, 5902831, 13034431]
    config.ehp_uim['fishing_xphrs'] = [14000, 28000, 35250, 60350, 71000, 76250, 81000, 90000]
  
    # config.ehp_uim['firemaking_tiers'] = [0, 3858, 21381, 101333]
    # config.ehp_uim['firemaking_xphrs'] = [30700, 46100, 69100, 144600]
  
    config.ehp_uim['firemaking_tiers'] = [0, 13363]
    config.ehp_uim['firemaking_xphrs'] = [45000, 130500]
  
    config.ehp_uim['crafting_tiers'] = [0]
    config.ehp_uim['crafting_xphrs'] = [20000]
  
    # config.ehp_uim['smithing_tiers'] = [0, 10050000, 13034000, 154200000]
    # config.ehp_uim['smithing_xphrs'] = [8950, 2984000, 8950, 45800000]
  
    config.ehp_uim['smithing_tiers'] = [0]
    config.ehp_uim['smithing_xphrs'] = [22700]
  
    config.ehp_uim['mining_tiers'] = [0]
    config.ehp_uim['mining_xphrs'] = [0]
  
    config.ehp_uim['runecraft_tiers'] = [0]
    config.ehp_uim['runecraft_xphrs'] = [4650]
    
    # Bonus XP (End): 
    # 0.2500 Smithing:Mining from 0 to 200000000 Mining xp 
    # 1.1350 Magic:Mining from 0 to 200000000 Mining xp 
    # 0.1380 Magic:Woodcutting from 0 to 200000000 Woodcutting xp 
    # 0.1380 Magic:Fishing from 0 to 200000000 Fishing xp 
    
    # Bonus XP (Start): 
    # 0.1071 Prayer:Cooking from 61512 to 200000000 Cooking xp   
    
    # ratio, bonus_for, bonus_from, start_xp, end_xp
    config.bonus_xp_reg = [[1.35, "magic", "woodcutting", 5018, 14833],
                           [0.972972973, "magic", "woodcutting", 14833, 41171],
                           [0.7346938776, "magic", "woodcutting", 41171, 101333],
                           [0.6625766871, "magic", "woodcutting", 101333, 302288],
                           [0.6, "magic", "woodcutting", 302288, 200000000],
                           [0.4245283019, "smithing", "magic", 50339, 166636],
                           [0.5636363636, "prayer", "mining", 41171, 302288],
                           [0.5438596491, "prayer", "mining", 302288, 200000000],
                           [0.2666, "prayer", "firemaking", 13363, 61512],
                           [0.1777, "prayer", "firemaking", 61512, 	273742],
                           [0.125, "prayer", "firemaking", 273742, 200000000],
                           ]

    config.bonus_xp_iron = [
                            # Attack
                            [0.1267, "prayer", "attack", 37224, 101333],
                            [0.1244, "prayer", "attack", 101333, 273742],
                            [0.1240, "prayer", "attack", 273742, 737627],
                            [0.1237, "prayer", "attack", 737627, 1210421],
                            [0.1236, "prayer", "attack", 1210421, 1629200],
                            [0.1235, "prayer", "attack", 1629200, 2192818],
                            [0.1234, "prayer", "attack", 2192818, 3258594],
                            [0.1234, "prayer", "attack", 3258594, 3972294],
                            [0.1233, "prayer", "attack", 3972294, 5346332],
                            [0.1233, "prayer", "attack", 5346332, 7944614],
                            [0.1232, "prayer", "attack", 7944614, 13034431],
                            [0.1151, "prayer", "attack", 13034431, 200000000],
                            [0.0071, "crafting", "attack", 37224, 13034431],
                            [0.0107, "crafting", "attack", 13034431, 200000000],
                            [0.0086, "smithing", "attack", 37224, 13034431],
                            [0.0101, "smithing", "attack", 13034431, 200000000],

                            # Strength
                            [0.1394, "prayer", "strength", 37224, 101333],
                            [0.1354, "prayer", "strength", 101333, 273742],
                            [0.1315, "prayer", "strength", 273742, 737627],
                            [0.1291, "prayer", "strength", 737627, 1210421],
                            [0.1285, "prayer", "strength", 1210421, 1629200],
                            [0.1278, "prayer", "strength", 1629200, 2192818],
                            [0.1270, "prayer", "strength", 2192818, 3258594],
                            [0.1263, "prayer", "strength", 3258594, 3972294],
                            [0.1259, "prayer", "strength", 3972294, 5346332],
                            [0.1252, "prayer", "strength", 5346332, 7944614],
                            [0.1246, "prayer", "strength", 7944614, 11805606],
                            [0.1232, "prayer", "strength", 11805606, 13034431],
                            [0.1151, "prayer", "strength", 13034431, 200000000],
                            [0.0071, "crafting", "strength", 37224, 13034431],
                            [0.0107, "crafting", "strength", 13034431, 200000000],
                            [0.0086, "smithing", "strength", 37224, 13034431],
                            [0.0101, "smithing", "strength", 13034431, 200000000],

                            # Defence
                            [0.1151, "prayer", "defence", 37224, 200000000],
                            [0.0107, "crafting", "defence", 37224, 200000000],
                            [0.0101, "smithing", "defence", 37224, 200000000],

                            # Ranged
                            [0.1416, "prayer", "ranged", 37224, 101333],
                            [0.0457, "prayer", "ranged", 101333, 13034431],
                            [0.0418, "prayer", "ranged", 13034431, 200000000],
                            [0.0071, "crafting", "ranged", 37224, 101333],
                            [0.0326, "crafting", "ranged", 101333, 13034431],
                            [0.0298, "crafting", "ranged", 13034431, 200000000],
                            [0.0086, "smithing", "ranged", 37224, 101333],
                            [0.01967, "smithing", "ranged", 101333, 13034431],
                            [0.0176, "smithing", "ranged", 13034431, 200000000],

                            # Crafting
                            [0.2610, "smithing", "crafting", 6291, 200000000],

                            # Runecrafting
                            # Woodcutting caps at 50m woodcutting
                            [0.3403, "woodcutting", "runecraft", 0, 146924946]
                           ]

    config.bonus_xp_uim = [
                            # Attack
                            [0.1267, "prayer", "attack", 37224, 101333],
                            [0.1244, "prayer", "attack", 101333, 273742],
                            [0.1240, "prayer", "attack", 273742, 737627],
                            [0.1237, "prayer", "attack", 737627, 1210421],
                            [0.1236, "prayer", "attack", 1210421, 1629200],
                            [0.1235, "prayer", "attack", 1629200, 2192818],
                            [0.1234, "prayer", "attack", 2192818, 3258594],
                            [0.1234, "prayer", "attack", 3258594, 3972294],
                            [0.1233, "prayer", "attack", 3972294, 5346332],
                            [0.1233, "prayer", "attack", 5346332, 7944614],
                            [0.1232, "prayer", "attack", 7944614, 13034431],
                            [0.1151, "prayer", "attack", 13034431, 200000000],
                            [0.0071, "crafting", "attack", 37224, 13034431],
                            [0.0107, "crafting", "attack", 13034431, 200000000],
                            [0.0086, "smithing", "attack", 37224, 13034431],
                            [0.0101, "smithing", "attack", 13034431, 200000000],

                            # Strength
                            [0.1394, "prayer", "strength", 37224, 101333],
                            [0.1354, "prayer", "strength", 101333, 273742],
                            [0.1315, "prayer", "strength", 273742, 737627],
                            [0.1291, "prayer", "strength", 737627, 1210421],
                            [0.1285, "prayer", "strength", 1210421, 1629200],
                            [0.1278, "prayer", "strength", 1629200, 2192818],
                            [0.1270, "prayer", "strength", 2192818, 3258594],
                            [0.1263, "prayer", "strength", 3258594, 3972294],
                            [0.1259, "prayer", "strength", 3972294, 5346332],
                            [0.1252, "prayer", "strength", 5346332, 7944614],
                            [0.1246, "prayer", "strength", 7944614, 11805606],
                            [0.1232, "prayer", "strength", 11805606, 13034431],
                            [0.1151, "prayer", "strength", 13034431, 200000000],
                            [0.0071, "crafting", "strength", 37224, 13034431],
                            [0.0107, "crafting", "strength", 13034431, 200000000],
                            [0.0086, "smithing", "strength", 37224, 13034431],
                            [0.0101, "smithing", "strength", 13034431, 200000000],

                            # Defence
                            [0.1151, "prayer", "defence", 37224, 200000000],
                            [0.0107, "crafting", "defence", 37224, 200000000],
                            [0.0101, "smithing", "defence", 37224, 200000000],

                            # Ranged
                            [0.1416, "prayer", "ranged", 37224, 101333],
                            [0.0457, "prayer", "ranged", 101333, 13034431],
                            [0.0418, "prayer", "ranged", 13034431, 200000000],
                            [0.0071, "crafting", "ranged", 37224, 101333],
                            [0.0326, "crafting", "ranged", 101333, 13034431],
                            [0.0298, "crafting", "ranged", 13034431, 200000000],
                            [0.0086, "smithing", "ranged", 37224, 101333],
                            [0.01967, "smithing", "ranged", 101333, 13034431],
                            [0.0176, "smithing", "ranged", 13034431, 200000000],

                            # Crafting
                            [0.2610, "smithing", "crafting", 6291, 200000000],

                            # Runecrafting
                            # Woodcutting caps at 50m woodcutting
                            [0.3403, "woodcutting", "runecraft", 0, 146924946]
                           ]
end

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )