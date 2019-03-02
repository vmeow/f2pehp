class Skill
  #ORDER OF SKILLS ON http://services.runescape.com/m=hiscore_oldschool/index_lite.ws?player=NAME
  HISCORES_SKILLS = ["overall", "attack", "defence", "strength", "hitpoints", "ranged", "prayer",
                   "magic", "cooking", "woodcutting", "p2p", "fishing", "firemaking", "crafting",
                   "smithing", "mining", "p2p", "p2p", "p2p", "p2p", "p2p", "runecraft", "p2p", 
                   "p2p", "p2p_minigame", "p2p_minigame", "p2p_minigame", "p2p_minigame", "p2p_minigame", "p2p_minigame", "p2p_minigame", "p2p_minigame", "lms"]
  
  F2P_SKILLS = ["attack", "strength", "defence", "hitpoints", "ranged", "prayer",
                "magic", "cooking", "woodcutting", "fishing", "firemaking", "crafting",
                "smithing", "mining", "runecraft"]
                       
  XP_TABLE = [0, 83, 174, 276, 388, 512, 650, 801, 969, 
      1154, 1358, 1584, 1833, 2107, 2411, 2746, 3115, 3523, 3973, 
      4470, 5018, 5624, 6291, 7028, 7842, 8740, 9730, 10824, 12031, 
      13363, 14833, 16456, 18247, 20224, 22406, 24815, 27473, 30408, 33648, 
      37224, 41171, 45529, 50339, 55649, 61512, 67983, 75127, 83014, 91721, 
      101333, 111945, 123660, 136594, 150872, 166636, 184040, 203254, 224466, 247886, 
      273742, 302288, 333804, 368599, 407015, 449428, 496254, 547953, 605032, 668051, 
      737627, 814445, 899257, 992895, 1096278, 1210421, 1336443, 1475581, 1629200, 1798808, 
      1986068, 2192818, 2421087, 2673114, 2951373, 3258594, 3597792, 3972294, 4385776, 4842295, 
      5346332, 5902831, 6517253, 71954629, 7944614, 8771558, 9684577, 10692629, 11805606, 13034431]

  LVL_TIERS = [32, 45, 60, 75, 90, 105, 120, 135, 150, 165, 
      180, 195, 210, 225, 240, 255, 270, 285, 300, 315, 
      330, 345, 360, 375, 390, 405, 420, 435, 450, 465, 
      480, 495, 510, 525, 540, 555, 570, 585, 600, 615, 
      630, 645, 660, 675, 690, 705, 720, 735, 750, 765, 
      780, 795, 810, 825, 840, 855, 870, 885, 900, 915, 
      930, 945, 960, 975, 990, 1005, 1020, 1035, 1050, 1065, 
      1080, 1095, 1110, 1125, 1140, 1155, 1170, 1185, 1200, 1215, 
      1230, 1245, 1260, 1275, 1290, 1305, 1320, 1335, 1350, 1365, 
      1380, 1395, 1410, 1425, 1440, 1455, 1470, 1485]
  
  LVL_XPS = [166, 522, 1104, 1940, 3072, 4550, 6408, 8721, 11540, 14938, 
      19008, 23829, 29498, 36165, 43936, 52955, 63414, 75487, 89400, 105378, 
      123728, 144693, 168672, 196050, 227240, 262710, 303072, 348899, 400890, 459823, 
      526592, 602151, 687616, 784210, 893340, 1016501, 1155504, 1312272, 1488960, 1688011, 
      1912218, 2164577, 2448556, 2768040, 3127218, 3530969, 3984672, 4494329, 5066650, 5709195, 
      6430320, 7239482, 8147088, 9164980, 10306240, 11585478, 13019028, 14625274, 16424520, 18439568,
      20695848, 23221737, 26048960, 29212820, 32752764, 36712851, 41142176, 46095519, 51633890, 57825595, 
      64746504, 72481335, 81124572, 90781575, 101569668, 113619737, 127077600, 142105832, 158885440, 177618258, 
      198529134, 221868462, 247915332, 276980490, 309410112, 345589578, 385948288, 430964255, 481169880, 537157621, 
      599587276, 6691780497, 746793716, 833298010, 929719392, 1037185013, 1156949388, 1290408669]

  EHP_REG = Hash.new
  EHP_IRON = Hash.new
  EHP_UIM = Hash.new
  
  EHP_REG['attack_method'] = "1 defence clan wars alts"
  EHP_REG['strength_method'] = "1 defence clan wars alts"
  EHP_REG['defence_method'] = "1 defence clan wars alts after 99 att/str"
  EHP_REG['ranged_method'] = "1 defence clan wars alts"
  EHP_REG['hitpoints_method'] = "0 time during combats"
  EHP_REG['prayer_method'] = "Big bones with mostly 0-tick banking"
  EHP_REG['magic_method'] = "Best spell, then curse splashing until 55, 0 time high alch/superheat during other skills"
  EHP_REG['cooking_method'] = "Best food, then wines"
  EHP_REG['woodcutting_method'] = "Best tree, then 3-tick willows with snow"
  EHP_REG['fishing_method'] = "Best fish, then 3-tick fly fishing with snow"
  EHP_REG['firemaking_method'] = "Best logs, double lane firemaking at grand exchange"
  EHP_REG['crafting_method'] = "Best leather item, then best gem"
  EHP_REG['smithing_method'] = "Best platebody until adamant platebody"
  EHP_REG['mining_method'] = "Best rock until iron, 3-tick empty shortbow on wildy kick alt iron at 51"
  EHP_REG['runecraft_method'] = "Suicide body tiara alts"
  
  EHP_IRON['attack_method'] = "1-20 cows/chickens/minotaurs, 20-40 hill giants, 40-70 moss giants, 70-99 ogresses with pray flicking"
  EHP_IRON['strength_method'] = "1-20 cows/chickens/minotaurs, 20-40 hill giants, 40-70 moss giants, 70-99 ogresses with pray flicking"
  EHP_IRON['defence_method'] = "1-20 cows/chickens/minotaurs, 20-40 hill giants, 40-70 moss giants, 70-99 ogresses with pray flicking"
  EHP_IRON['ranged_method'] = "1-20 minotaurs, 20-40 hill giants, 40-50 moss giants, 50-99 ogresses, with pray flicking"
  EHP_IRON['hitpoints_method'] = "0 time during combats"
  EHP_IRON['prayer_method'] = "Boneyard and 0-time big bones from giants/ogresses"
  EHP_IRON['magic_method'] = "Best spell, then 0-time teleport/superheat/high alch during other skills"
  EHP_IRON['cooking_method'] = "Best fish until trout/salmon, 3.5-ticked"
  EHP_IRON['woodcutting_method'] = "Best tree until willows, 3-ticked with snow"
  EHP_IRON['fishing_method'] = "Best fish until trout/salmon, 3-ticked with snow"
  EHP_IRON['firemaking_method'] = "Best tree until willows, during woodcutting"
  EHP_IRON['crafting_method'] = "Leather, then symbols, then tiaras and gem amulets from ogresses"
  EHP_IRON['smithing_method'] = "Knight's sword, superheat iron after telegrabbing wildy nats, mining guild and falador teleport iron platebodies and 0-time silver/gold smelting"
  EHP_IRON['mining_method'] = "0 time during crafting, smithing, runecraft"
  EHP_IRON['runecraft_method'] = "Ess mine to earth runes with varrock tele, with 0-time crafting guild air rc"
  
  EHP_UIM['attack_method'] = "1-20 cows/chickens/minotaurs, 20-40 hill giants, 40-70 moss giants, 70-99 ogresses with pray flicking"
  EHP_UIM['strength_method'] = "1-20 cows/chickens/minotaurs, 20-40 hill giants, 40-70 moss giants, 70-99 ogresses with pray flicking"
  EHP_UIM['defence_method'] = "1-20 cows/chickens/minotaurs, 20-40 hill giants, 40-70 moss giants, 70-99 ogresses with pray flicking"
  EHP_UIM['ranged_method'] = "1-20 minotaurs, 20-40 hill giants, 40-50 moss giants, 50-99 ogresses, with pray flicking"
  EHP_UIM['hitpoints_method'] = "0 time during combats"
  EHP_UIM['prayer_method'] = "Boneyard and 0-time big bones from giants/ogresses"
  EHP_UIM['magic_method'] = "Best spell, then 0-time teleport/superheat/high alch during other skills"
  EHP_UIM['cooking_method'] = "Best fish until trout/salmon, 3.5-ticked"
  EHP_UIM['woodcutting_method'] = "Best tree until willows, 3-ticked with snow"
  EHP_UIM['fishing_method'] = "Best fish until trout/salmon, 3-ticked with snow"
  EHP_UIM['firemaking_method'] = "Best tree until willows, during woodcutting"
  EHP_UIM['crafting_method'] = "Leather, then symbols, then tiaras with 0-time cut and dropped gems from ogresses"
  EHP_UIM['smithing_method'] = "Knight's sword, superheat iron after telegrabbing wildy nats, varrock west and falador tele iron platebodies and 0-time silver smelting"
  EHP_UIM['mining_method'] = "0 time during crafting, smithing, runecraft"
  EHP_UIM['runecraft_method'] = "Ess mine to earth runes with varrock tele"

  # EHP_REG['attack_tiers'] = [0, 37224, 100000, 1000000, 1986068, 3000000, 5346332, 13034431]
  # EHP_REG['attack_xphrs'] = [5300, 25450, 29500, 37900, 44800, 46900, 50800, 53500]

  # EHP_REG['strength_tiers'] = [0, 37224, 100000, 1000000, 1986068, 3000000, 5346332, 13034431]
  # EHP_REG['strength_xphrs'] = [5300, 25450, 29500, 37900, 44800, 46900, 50800, 53500]

  # EHP_REG['defence_tiers'] = [0, 37224, 100000, 1000000, 1986068, 3000000, 5346332, 13034431]
  # EHP_REG['defence_xphrs'] = [5300, 25450, 29500, 37900, 44800, 46900, 50800, 53500]

  # EHP_REG['hitpoints_tiers'] = [0]
  # EHP_REG['hitpoints_xphrs'] = [0]

  # EHP_REG['ranged_tiers'] = [0, 37224, 100000, 1000000, 1986068, 3000000, 5346332, 13034431]
  # EHP_REG['ranged_xphrs'] = [4900, 24650, 30500, 44800, 45900, 46100, 49200, 55000]
  EHP_REG['attack_tiers'] = [0, 37224, 100000, 1000000, 1986068, 3000000, 5346332, 13034431]
  EHP_REG['attack_xphrs'] = [7200, 14400, 28900, 43000, 51000, 57800, 63000, 68000]

  EHP_REG['strength_tiers'] = [0, 37224, 100000, 1000000, 1986068, 3000000, 5346332, 13034431]
  EHP_REG['strength_xphrs'] = [7200, 14400, 28900, 43000, 51000, 57800, 63000, 68000]

  EHP_REG['defence_tiers'] = [0]
  EHP_REG['defence_xphrs'] = [68000]

  EHP_REG['hitpoints_tiers'] = [0]
  EHP_REG['hitpoints_xphrs'] = [0]

  EHP_REG['ranged_tiers'] = [0, 37224, 100000, 1000000, 1986068, 3000000, 5346332, 13034431]
  EHP_REG['ranged_xphrs'] = [7000, 14000, 28000, 42500, 49000, 56500, 61200, 66000]

  EHP_REG['prayer_tiers'] = [0]
  EHP_REG['prayer_xphrs'] =[43000]

  EHP_REG['magic_tiers'] = [0, 174, 1358, 3973, 5018, 166636]
  EHP_REG['magic_xphrs'] = [5000, 15600, 25200, 34800, 72000, 199822941]

  EHP_REG['cooking_tiers'] = [0, 7842, 37224, 737627]
  EHP_REG['cooking_xphrs'] = [40000, 130000, 175000, 480000]

  EHP_REG['woodcutting_tiers'] = [0, 2411, 13363, 41171, 302288, 1986068, 5346332, 13034431]
  EHP_REG['woodcutting_xphrs'] = [7000, 15000, 28000, 40000, 50000, 60000, 70000, 78500]

  EHP_REG['fishing_tiers'] = [0, 4470, 13363, 273742, 737627, 2500000, 6000000, 13034431]
  EHP_REG['fishing_xphrs'] = [14000, 28000, 35000, 45000, 55000, 65000, 70000, 78500]

  EHP_REG['firemaking_tiers'] = [0, 13363, 61512, 273742]
  EHP_REG['firemaking_xphrs'] = [45000, 130500, 195750, 293625]

  EHP_REG['crafting_tiers'] = [0, 4470, 50339]
  EHP_REG['crafting_xphrs'] = [57000, 135000, 290000]

  # EHP_REG['smithing_tiers'] = [0, 37224, 605032, 4385776, 170000000]
  # EHP_REG['smithing_xphrs'] = [40000, 129000, 200000, 250000, 30000000]
  
  # EHP_REG['mining_tiers'] = [0, 14833, 41171, 111945] 
  # EHP_REG['mining_xphrs'] = [4000, 12000, 25000, 57000]

  # EHP_REG['runecraft_tiers'] = [0]
  # EHP_REG['runecraft_xphrs'] = [26000]
  EHP_REG['smithing_tiers'] = [0, 2783114, 4385776, 150000000]
  EHP_REG['smithing_xphrs'] = [2673114, 212000, 265000, 50000000]

  EHP_REG['mining_tiers'] = [0, 14833, 41171, 111945, 737627] 
  EHP_REG['mining_xphrs'] = [4000, 12000, 25000, 57000, 65000]

  EHP_REG['runecraft_tiers'] = [0]
  EHP_REG['runecraft_xphrs'] = [55000]



  EHP_IRON['attack_tiers'] = [0, 37224, 100000, 273742, 737627, 1210421, 1986068, 3258594, 6517253, 13034431]
  EHP_IRON['attack_xphrs'] = [5000, 23900, 28900, 35600, 30400, 33000, 35550, 37900, 42250, 47400]

  EHP_IRON['strength_tiers'] = [0, 37224, 100000, 273742, 737627, 1210421, 1986068, 3258594, 6517253, 13034431] 
  EHP_IRON['strength_xphrs'] = [5000, 23900, 28900, 35600, 30400, 33000, 35550, 37900, 42250, 47400]

  EHP_IRON['defence_tiers'] = [0, 37224, 100000, 273742, 737627, 1210421, 1986068, 3258594, 6517253, 13034431]
  EHP_IRON['defence_xphrs'] = [5000, 23900, 28900, 35600, 30400, 33000, 35550, 37900, 42250, 47400]

  EHP_IRON['hitpoints_tiers'] = [0]
  EHP_IRON['hitpoints_xphrs'] = [0]

  EHP_IRON['ranged_tiers'] = [0, 37224, 101333, 184040, 273742, 368599, 547953, 737627, 992895, 1475581, 1986068, 2673114, 3972294, 5346332, 7944614, 10692629, 13034431] 
  EHP_IRON['ranged_xphrs'] = [4000, 22850, 19950, 23450, 24400, 27050, 30100, 30550, 33250, 34000, 36900, 37300, 40300, 40650, 43400, 46350, 46550]

  EHP_IRON['prayer_tiers'] = [0, 10680000, 13034000, 163880000]
  EHP_IRON['prayer_xphrs'] = [9300, 2350000, 9300, 36120000]

  # EHP_IRON['magic_tiers'] = [0, 3973, 247886, 3500000, 13034000, 53700000]
  # EHP_IRON['magic_xphrs'] = [5000, 34800, 51700, 9534000, 51700, 146300000]

  EHP_IRON['magic_tiers'] = [0, 3973, 18247]
  EHP_IRON['magic_xphrs'] = [5000, 34800, 199981753]

  # EHP_IRON['cooking_tiers'] = [0, 101333]
  # EHP_IRON['cooking_xphrs'] = [40000, 120000]

  EHP_IRON['cooking_tiers'] = [0]
  EHP_IRON['cooking_xphrs'] = [0]

  EHP_IRON['woodcutting_tiers'] = [0, 2411, 13363, 41171, 302288, 1986068, 5346332, 13034431, 150000000, 194700000]
  EHP_IRON['woodcutting_xphrs'] = [7000, 15000, 28000, 40000, 50000, 60000, 70000, 75000, 78500, 5300000]

  # EHP_IRON['fishing_tiers'] = [0, 4470, 13363, 273742, 737627, 2500000, 6000000, 13034431, 149000000]
  # EHP_IRON['fishing_xphrs'] = [14000, 28000, 35000, 45000, 55000, 65000, 70000, 75000, 78500]

  EHP_IRON['fishing_tiers'] = [0, 4470, 13363, 273742, 737627, 2500000, 6000000, 13034431, 149000000]
  EHP_IRON['fishing_xphrs'] = [14000, 26700, 33300, 42800, 52400, 61900, 66400, 71400, 78500]

  # EHP_IRON['firemaking_tiers'] = [0, 3858, 21381, 101333]
  # EHP_IRON['firemaking_xphrs'] = [30700, 46100, 69100, 144600]

  EHP_IRON['firemaking_tiers'] = [0, 3858, 21381, 101333, 190400000]
  EHP_IRON['firemaking_xphrs'] = [30700, 46100, 69100, 144600, 9600000]

  EHP_IRON['crafting_tiers'] = [0]
  EHP_IRON['crafting_xphrs'] = [15550]

  # EHP_IRON['smithing_tiers'] = [0, 10050000, 13034000, 154200000]
  # EHP_IRON['smithing_xphrs'] = [8950, 2984000, 8950, 45800000]

  EHP_IRON['smithing_tiers'] = [0, 10050000, 13034000, 154200000]
  EHP_IRON['smithing_xphrs'] = [15200, 2984000, 15200, 45800000]

  EHP_IRON['mining_tiers'] = [0]
  EHP_IRON['mining_xphrs'] = [0]

  EHP_IRON['runecraft_tiers'] = [0, 11970000, 13034000, 183673000]
  EHP_IRON['runecraft_xphrs'] = [3970, 1060000, 3970, 16327000]



  EHP_UIM['attack_tiers'] = [0, 37224, 100000, 273742, 737627, 1210421, 1986068, 3258594, 6517253, 13034431]
  EHP_UIM['attack_xphrs'] = [5000, 23900, 28900, 35600, 30400, 33000, 35550, 37900, 42250, 47400]

  EHP_UIM['strength_tiers'] = [0, 37224, 100000, 273742, 737627, 1210421, 1986068, 3258594, 6517253, 13034431] 
  EHP_UIM['strength_xphrs'] = [5000, 23900, 28900, 35600, 30400, 33000, 35550, 37900, 42250, 47400]

  EHP_UIM['defence_tiers'] = [0, 37224, 100000, 273742, 737627, 1210421, 1986068, 3258594, 6517253, 13034431]
  EHP_UIM['defence_xphrs'] = [5000, 23900, 28900, 35600, 30400, 33000, 35550, 37900, 42250, 47400]

  EHP_UIM['hitpoints_tiers'] = [0]
  EHP_UIM['hitpoints_xphrs'] = [0]

  EHP_UIM['ranged_tiers'] = [0, 37224, 101333, 184040, 273742, 368599, 547953, 737627, 992895, 1475581, 1986068, 2673114, 3972294, 5346332, 7944614, 10692629, 13034431] 
  EHP_UIM['ranged_xphrs'] = [4000, 22850, 19950, 23450, 24400, 27050, 30100, 30550, 33250, 34000, 36900, 37300, 40300, 40650, 43400, 46350, 46550]
  
  EHP_UIM['prayer_tiers'] = [0, 10680000, 13034000, 163880000]
  EHP_UIM['prayer_xphrs'] = [9300, 2350000, 9300, 36120000]

  # EHP_UIM['magic_tiers'] = [0, 3973, 247886, 3500000, 13034000, 53700000]
  # EHP_UIM['magic_xphrs'] = [5000, 34800, 51700, 9534000, 51700, 146300000]

  EHP_UIM['magic_tiers'] = [0, 3973, 18247]
  EHP_UIM['magic_xphrs'] = [5000, 34800, 199981753]

  EHP_UIM['magic_tiers'] = [0, 3973, 247886, 3500000, 13034000, 53700000]
  EHP_UIM['magic_xphrs'] = [5000, 34800, 51700, 9534000, 51700, 146300000]

  # EHP_UIM['cooking_tiers'] = [0, 101333]
  # EHP_UIM['cooking_xphrs'] = [40000, 120000]

  EHP_UIM['cooking_tiers'] = [0]
  EHP_UIM['cooking_xphrs'] = [0]

  # EHP_UIM['woodcutting_tiers'] = [0, 2411, 13363, 41171, 302288, 1986068, 5346332, 13034431, 150000000]
  # EHP_UIM['woodcutting_xphrs'] = [7000, 15000, 28000, 40000, 50000, 60000, 70000, 75000, 78500]

  EHP_UIM['woodcutting_tiers'] = [0, 2411, 13363, 41171, 302288, 1986068, 5346332, 13034431, 150000000, 194700000]
  EHP_UIM['woodcutting_xphrs'] = [7000, 15000, 28000, 40000, 50000, 60000, 70000, 75000, 78500, 5300000]

  # EHP_UIM['fishing_tiers'] = [0, 4470, 13363, 273742, 737627, 2500000, 6000000, 13034431, 149000000]
  # EHP_UIM['fishing_xphrs'] = [14000, 28000, 35000, 45000, 55000, 65000, 70000, 75000, 78500]

  EHP_UIM['fishing_tiers'] = [0, 4470, 13363, 273742, 737627, 2500000, 6000000, 13034431, 149000000]
  EHP_UIM['fishing_xphrs'] = [14000, 26700, 33300, 42800, 52400, 61900, 66400, 71400, 78500]

  # EHP_UIM['firemaking_tiers'] = [0, 3858, 21381, 101333]
  # EHP_UIM['firemaking_xphrs'] = [30700, 46100, 69100, 144600]

  EHP_UIM['firemaking_tiers'] = [0, 3858, 21381, 101333, 190400000]
  EHP_UIM['firemaking_xphrs'] = [30700, 46100, 69100, 144600, 9600000]

  EHP_UIM['crafting_tiers'] = [0, 11275000, 13034000, 173000000] 
  EHP_UIM['crafting_xphrs'] = [13600, 1759250, 13600, 27000000]

  # EHP_UIM['smithing_tiers'] = [0, 10092000, 13034000, 154850000]
  # EHP_UIM['smithing_xphrs'] = [7650, 2942000, 7650, 45150000]

  EHP_UIM['smithing_tiers'] = [0, 10092000, 13034000, 154850000]
  EHP_UIM['smithing_xphrs'] = [15200, 2942000, 15200, 45150000]

  EHP_UIM['mining_tiers'] = [0] 
  EHP_UIM['mining_xphrs'] =[0]

  EHP_UIM['runecraft_tiers'] = [0] 
  EHP_UIM['runecraft_xphrs'] = [3970]
  
  def self.skills
    SKILLS
  end
  
  def self.f2p_skills
    F2P_SKILLS
  end
end
