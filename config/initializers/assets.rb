# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path
F2POSRSRanks::Application.configure do
   config.version = "F2P OSRS Ranks v0.5.6a"
   
    #ORDER OF SKILLS ON http://services.runescape.com/m=hiscore_oldschool/index_lite.ws?player=NAME
    config.skills = ["overall", "attack", "defence", "strength", "hitpoints", "ranged", "prayer",
                     "magic", "cooking", "woodcutting", "p2p", "fishing", "firemaking", "crafting",
                     "smithing", "mining", "p2p", "p2p", "p2p", "p2p", "p2p", "runecraft", "p2p", 
                     "p2p", "p2p", "p2p", "p2p", "p2p", "p2p", "p2p", "lms", "p2p", "p2p"]
    
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
    config.ehp_reg['attack_tiers'] = [0, 37224, 100000, 1000000, 1986068, 3000000, 5346332, 13034431]
    config.ehp_reg['attack_xphrs'] = [7200, 14400, 28900, 43000, 51000, 57800, 63000, 68000]

    config.ehp_reg['strength_tiers'] = [0, 37224, 100000, 1000000, 1986068, 3000000, 5346332, 13034431]
    config.ehp_reg['strength_xphrs'] = [7200, 14400, 28900, 43000, 51000, 57800, 63000, 68000]

    config.ehp_reg['defence_tiers'] = [0, 37224, 100000, 1000000, 1986068, 3000000, 5346332, 13034431]
    config.ehp_reg['defence_xphrs'] = [7200, 14400, 28900, 43000, 51000, 57800, 63000, 68000]

    config.ehp_reg['hitpoints_tiers'] = [0]
    config.ehp_reg['hitpoints_xphrs'] = [0]

    config.ehp_reg['ranged_tiers'] = [0, 37224, 100000, 1000000, 1986068, 3000000, 5346332, 13034431]
    config.ehp_reg['ranged_xphrs'] = [7000, 14000, 28000, 42500, 49000, 56500, 61200, 66000]

    config.ehp_reg['prayer_tiers'] = [0, 160000000]
    config.ehp_reg['prayer_xphrs'] =[43000, 267000]

    config.ehp_reg['magic_tiers'] = [0, 174, 1358, 3973, 5018, 166636]
    config.ehp_reg['magic_xphrs'] = [5000, 15600, 25200, 34800, 72000, 199822941]

    config.ehp_reg['cooking_tiers'] = [0, 7842, 37224, 737627]
    config.ehp_reg['cooking_xphrs'] = [40000, 130000, 175000, 480000]

    config.ehp_reg['woodcutting_tiers'] = [0, 2411, 13363, 41171, 302288, 1986068, 5346332, 13034431]
    config.ehp_reg['woodcutting_xphrs'] = [7000, 15000, 28000, 40000, 50000, 60000, 70000, 78500]

    config.ehp_reg['fishing_tiers'] = [0, 4470, 13363, 273742, 737627, 2500000, 6000000, 13034431]
    config.ehp_reg['fishing_xphrs'] = [14000, 28000, 35000, 45000, 55000, 65000, 70000, 78500]

    config.ehp_reg['firemaking_tiers'] = [0, 13363, 61512, 273742]
    config.ehp_reg['firemaking_xphrs'] = [45000, 130500, 195750, 293625]

    config.ehp_reg['crafting_tiers'] = [0, 4470, 50339]
    config.ehp_reg['crafting_xphrs'] = [57000, 135000, 290000]

    config.ehp_reg['smithing_tiers'] = [0, 37224, 605032, 4385776, 170000000]
    config.ehp_reg['smithing_xphrs'] = [40000, 103000, 220000, 275000, 30000000]

    config.ehp_reg['mining_tiers'] = [0, 14833, 41171, 111945, 737627] 
    config.ehp_reg['mining_xphrs'] = [4000, 12000, 25000, 57000, 65000]

    config.ehp_reg['runecraft_tiers'] = [0]
    config.ehp_reg['runecraft_xphrs'] = [40000]



    config.ehp_iron['attack_tiers'] = [0, 37224, 100000, 1000000, 1986068, 3000000, 5346332, 13034431]
    config.ehp_iron['attack_xphrs'] = [5000, 10000, 20000, 30000, 35000, 40000, 44000, 47000]

    config.ehp_iron['strength_tiers'] = [0, 37224, 100000, 1000000, 1986068, 3000000, 5346332, 13034431] 
    config.ehp_iron['strength_xphrs'] = [5000, 10000, 20000, 30000, 35000, 40000, 44000, 47000]

    config.ehp_iron['defence_tiers'] = [0, 37224, 100000, 1000000, 1986068, 3000000, 5346332, 13034431]
    config.ehp_iron['defence_xphrs'] = [5000, 10000, 20000, 30000, 35000, 40000, 44000, 47000]

    config.ehp_iron['hitpoints_tiers'] = [0]
    config.ehp_iron['hitpoints_xphrs'] = [0]

    config.ehp_iron['ranged_tiers'] = [0, 37224, 100000, 1000000, 1986068, 3000000, 5346332, 13034431] 
    config.ehp_iron['ranged_xphrs'] = [4000, 9000, 17000, 27000, 30000, 35000, 40000, 42000]

    config.ehp_iron['prayer_tiers'] = [0]
    config.ehp_iron['prayer_xphrs'] = [15200]

    config.ehp_iron['magic_tiers'] = [0, 3973, 33648]
    config.ehp_iron['magic_xphrs'] = [5000, 34800, 56100]

    #config.ehp_iron['cooking_tiers'] = [0]
    #config.ehp_iron['cooking_xphrs'] = [0]
    config.ehp_iron['cooking_tiers'] = [0, 101333, 224466]
    config.ehp_iron['cooking_xphrs'] = [40000, 140000, 156800]

    #config.ehp_iron['woodcutting_tiers'] = [0, 2411, 13363, 41171, 9800000]
    #config.ehp_iron['woodcutting_xphrs'] = [6000, 12000, 24000, 34700, 72000]
    config.ehp_iron['woodcutting_tiers'] = [0, 2411, 13363, 41171, 302288, 1986068, 5346332, 13034431]
    config.ehp_iron['woodcutting_xphrs'] = [7000, 15000, 28000, 40000, 50000, 60000, 70000, 78500]

    #config.ehp_iron['fishing_tiers'] = [0, 4470, 13363, 273742, 737627, 2500000, 6000000, 9600000]
    #config.ehp_iron['fishing_xphrs'] = [12000, 22000, 26000, 28000, 30000, 32000, 38000, 72000]
    config.ehp_iron['fishing_tiers'] = [0, 4470, 13363, 273742, 737627, 2500000, 6000000, 13034431]
    config.ehp_iron['fishing_xphrs'] = [14000, 28000, 35000, 45000, 55000, 65000, 70000, 78500]

    #config.ehp_iron['firemaking_tiers'] = [0]
    #config.ehp_iron['firemaking_xphrs'] = [0]
    config.ehp_iron['firemaking_tiers'] = [0, 3858, 21381, 101333]
    config.ehp_iron['firemaking_xphrs'] = [45000, 67500, 101250, 126000]

    config.ehp_iron['crafting_tiers'] = [0]
    config.ehp_iron['crafting_xphrs'] = [13300]

    config.ehp_iron['smithing_tiers'] = [0]
    config.ehp_iron['smithing_xphrs'] = [8100]

    config.ehp_iron['mining_tiers'] = [0]
    config.ehp_iron['mining_xphrs'] = [0]

    config.ehp_iron['runecraft_tiers'] = [0]
    config.ehp_iron['runecraft_xphrs'] = [4285]



    config.ehp_uim['attack_tiers'] = [0, 37224, 100000, 1000000, 1986068, 3000000, 5346332, 13034431]
    config.ehp_uim['attack_xphrs'] = [5000, 10000, 20000, 30000, 35000, 40000, 44000, 47000]

    config.ehp_uim['strength_tiers'] = [0, 37224, 100000, 1000000, 1986068, 3000000, 5346332, 13034431] 
    config.ehp_uim['strength_xphrs'] = [5000, 10000, 20000, 30000, 35000, 40000, 44000, 47000]

    config.ehp_uim['defence_tiers'] = [0, 37224, 100000, 1000000, 1986068, 3000000, 5346332, 13034431]
    config.ehp_uim['defence_xphrs'] =  [5000, 10000, 20000, 30000, 35000, 40000, 44000, 47000]

    config.ehp_uim['hitpoints_tiers'] = [0]
    config.ehp_uim['hitpoints_xphrs'] = [0]

    config.ehp_uim['ranged_tiers'] = [0, 37224, 100000, 1000000, 1986068, 3000000, 5346332, 13034431]
    config.ehp_uim['ranged_xphrs'] = [4000, 9000, 17000, 27000, 30000, 35000, 40000, 42000]

    config.ehp_uim['prayer_tiers'] = [0]
    config.ehp_uim['prayer_xphrs'] = [15200]

    config.ehp_uim['magic_tiers'] = [0, 3973, 33648]
    config.ehp_uim['magic_xphrs'] = [5000, 34800, 45600]

    #config.ehp_uim['cooking_tiers'] = [0] 
    #config.ehp_uim['cooking_xphrs'] = [0]
    config.ehp_uim['cooking_tiers'] = [0, 101333, 224466]
    config.ehp_uim['cooking_xphrs'] = [40000, 140000, 156800]

    #config.ehp_uim['woodcutting_tiers'] = [0, 2411, 13363, 41171, 9800000]
    #config.ehp_uim['woodcutting_xphrs'] = [6000, 12000, 24000, 34700, 72000]
    config.ehp_uim['woodcutting_tiers'] = [0, 2411, 13363, 41171, 302288, 1986068, 5346332, 13034431]
    config.ehp_uim['woodcutting_xphrs'] = [7000, 15000, 28000, 40000, 50000, 60000, 70000, 78500]

    #config.ehp_uim['fishing_tiers'] = [0, 4470, 13363, 273742, 737627, 2500000, 6000000, 9600000] 
    #config.ehp_uim['fishing_xphrs'] = [12000, 22000, 26000, 28000, 30000, 32000, 38000, 72000]
    config.ehp_uim['fishing_tiers'] = [0, 4470, 13363, 273742, 737627, 2500000, 6000000, 13034431]
    config.ehp_uim['fishing_xphrs'] = [14000, 28000, 35000, 45000, 55000, 65000, 70000, 78500]

    #config.ehp_uim['firemaking_tiers'] = [0]
    #config.ehp_uim['firemaking_xphrs'] = [0]
    config.ehp_uim['firemaking_tiers'] = [0, 3858, 21381, 101333]
    config.ehp_uim['firemaking_xphrs'] = [45000, 67500, 101250, 126000]

    config.ehp_uim['crafting_tiers'] = [0] 
    config.ehp_uim['crafting_xphrs'] = [0]

    config.ehp_uim['smithing_tiers'] = [0, 9800000]
    config.ehp_uim['smithing_xphrs'] = [4800, 6900]

    config.ehp_uim['mining_tiers'] = [0] 
    config.ehp_uim['mining_xphrs'] =[0]

    config.ehp_uim['runecraft_tiers'] = [0] 
    config.ehp_uim['runecraft_xphrs'] = [3500]
end

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
