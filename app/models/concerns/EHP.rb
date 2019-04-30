module EHP
  include Skill

  EHP_REG = Hash.new
  EHP_IRON = Hash.new
  EHP_UIM = Hash.new
  
  EHP_REG['attack_method'] = "1 defence clan wars alts"
  EHP_REG['strength_method'] = "1 defence clan wars alts"
  EHP_REG['defence_method'] = "1 defence clan wars alts after 99 att/str"
  EHP_REG['ranged_method'] = "1 defence clan wars alts"
  EHP_REG['hitpoints_method'] = "0 time during combats"
  EHP_REG['prayer_method'] = "Big bones"
  EHP_REG['magic_method'] = "Best spell, then curse splashing until 55, 0 time high alch/superheat during other skills"
  EHP_REG['cooking_method'] = "0-time cooking from Erie fishing"
  EHP_REG['woodcutting_method'] = "Best tree, then 3-tick willows with snow"
  EHP_REG['fishing_method'] = "Best fish, then 3-tick Erie fishing with 0-time cooking"
  EHP_REG['firemaking_method'] = "Best logs, double lane firemaking at grand exchange"
  EHP_REG['crafting_method'] = "Best leather item, then best gem"
  EHP_REG['smithing_method'] = "Best platebody until adamant platebody, with alts to trade"
  EHP_REG['mining_method'] = "Best rock until iron, 3-tick empty shortbow on wildy kick alt iron at 51"
  EHP_REG['runecraft_method'] = "Suicide body tiara alts"
  
  EHP_IRON['attack_method'] = "1-20 cows/chickens/minotaurs, 20-40 hill giants, 40-70 moss giants, 70-99 ogresses with pray flicking"
  EHP_IRON['strength_method'] = "1-20 cows/chickens/minotaurs, 20-40 hill giants, 40-70 moss giants, 70-99 ogresses with pray flicking"
  EHP_IRON['defence_method'] = "1-20 cows/chickens/minotaurs, 20-40 hill giants, 40-70 moss giants, 70-99 ogresses with pray flicking"
  EHP_IRON['ranged_method'] = "1-20 minotaurs, 20-40 hill giants, 40-50 moss giants, 50-99 ogresses, with pray flicking"
  EHP_IRON['hitpoints_method'] = "0 time during combats"
  EHP_IRON['prayer_method'] = "Boneyard and 0-time big bones from giants/ogresses"
  EHP_IRON['magic_method'] = "Best spell, then 0-time teleport/superheat/high alch during other skills"
  EHP_IRON['cooking_method'] = "Best fish until trout/salmon, 0-time while 3-tick fishing (Erie fishing)."
  EHP_IRON['woodcutting_method'] = "Best tree until willows, 3-ticked with snow, bonus xp from Erie fishing"
  EHP_IRON['fishing_method'] = "Best fish until trout/salmon, 3-ticked with snow/cooked fish (Erie fishing)"
  EHP_IRON['firemaking_method'] = "Best tree until willows, during woodcutting, bonus xp from Erie fishing"
  EHP_IRON['crafting_method'] = "Leather, then symbols, then Varrock SW chronicle teleport tiaras and 0 time gems from ogresses"
  EHP_IRON['smithing_method'] = "Knight's sword, superheat iron after telegrabbing wildy nats, mining guild and falador tele iron platebodies and 0-time silver smelting"
  EHP_IRON['mining_method'] = "0 time during crafting, smithing, runecraft"
  EHP_IRON['runecraft_method'] = "Ess mine to earth runes with varrock tele"
  
  EHP_UIM['attack_method'] = "1-20 cows/chickens/minotaurs, 20-40 hill giants, 40-70 moss giants, 70-99 ogresses with pray flicking"
  EHP_UIM['strength_method'] = "1-20 cows/chickens/minotaurs, 20-40 hill giants, 40-70 moss giants, 70-99 ogresses with pray flicking"
  EHP_UIM['defence_method'] = "1-20 cows/chickens/minotaurs, 20-40 hill giants, 40-70 moss giants, 70-99 ogresses with pray flicking"
  EHP_UIM['ranged_method'] = "1-20 minotaurs, 20-40 hill giants, 40-50 moss giants, 50-99 ogresses, with pray flicking"
  EHP_UIM['hitpoints_method'] = "0 time during combats"
  EHP_UIM['prayer_method'] = "Boneyard and 0-time big bones from giants/ogresses"
  EHP_UIM['magic_method'] = "Best spell, then 0-time teleport/superheat/high alch during other skills"
  EHP_UIM['cooking_method'] = "Best fish until trout/salmon, 0-time while 3-tick fishing (Erie fishing)."
  EHP_UIM['woodcutting_method'] = "Best tree until willows, 3-ticked with snow, bonus xp from Erie fishing"
  EHP_UIM['fishing_method'] = "Best fish until trout/salmon, 3-ticked with snow/cooked fish (Erie fishing)"
  EHP_UIM['firemaking_method'] = "Best tree until willows, during woodcutting, bonus xp from Erie fishing"
  EHP_UIM['crafting_method'] = "Leather, then symbols, then Varrock SW chronicle teleport tiaras and 0 time gems from ogresses"
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

  EHP_REG['magic_tiers'] = [0, 174, 1358, 3973, 5018]
  EHP_REG['magic_xphrs'] = [5000, 15600, 25200, 34800, 0]

  EHP_REG['cooking_tiers'] = [0]
  EHP_REG['cooking_xphrs'] = [0]

  EHP_REG['woodcutting_tiers'] = [0, 2411, 13363, 41171, 302288, 1986068, 5346332, 13034431]
  EHP_REG['woodcutting_xphrs'] = [7000, 15000, 28000, 40000, 50000, 60000, 70000, 78500]

  EHP_REG['fishing_tiers'] = [0, 4470, 13363, 273742, 737627, 2500000, 6000000, 13034431, 149000000]
  EHP_REG['fishing_xphrs'] = [14000, 26700, 33300, 42800, 52400, 61900, 66400, 71400, 78500]  

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
  EHP_REG['smithing_tiers'] = [0, 37224, 605032, 2783114, 4385776]
  EHP_REG['smithing_xphrs'] = [40000, 129000, 200000, 212000, 265000]

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

  EHP_IRON['prayer_tiers'] = [0]
  EHP_IRON['prayer_xphrs'] = [9300]

  # EHP_IRON['magic_tiers'] = [0, 3973, 247886, 3500000, 13034000, 53700000]
  # EHP_IRON['magic_xphrs'] = [5000, 34800, 51700, 9534000, 51700, 146300000]

  EHP_IRON['magic_tiers'] = [0, 174, 3973, 7842]
  EHP_IRON['magic_xphrs'] = [5000, 15600, 34800, 0]

  # EHP_IRON['cooking_tiers'] = [0, 101333]
  # EHP_IRON['cooking_xphrs'] = [40000, 120000]

  EHP_IRON['cooking_tiers'] = [0]
  EHP_IRON['cooking_xphrs'] = [0]

  EHP_IRON['woodcutting_tiers'] = [0, 2411, 13363, 41171, 302288, 1986068, 5346332, 13034431, 150000000]
  EHP_IRON['woodcutting_xphrs'] = [4000, 8500, 16000, 22800, 28500, 34300, 40000, 42850, 78500]

  # EHP_IRON['fishing_tiers'] = [0, 4470, 13363, 273742, 737627, 2500000, 6000000, 13034431, 149000000]
  # EHP_IRON['fishing_xphrs'] = [14000, 28000, 35000, 45000, 55000, 65000, 70000, 75000, 78500]

  EHP_IRON['fishing_tiers'] = [0, 4470, 13363, 273742, 737627, 2500000, 6000000, 13034431, 149000000]
  EHP_IRON['fishing_xphrs'] = [14000, 26700, 33300, 42800, 52400, 61900, 66400, 71400, 78500]

  # EHP_IRON['firemaking_tiers'] = [0, 3858, 21381, 101333]
  # EHP_IRON['firemaking_xphrs'] = [30700, 46100, 69100, 144600]

  EHP_IRON['firemaking_tiers'] = [0]
  EHP_IRON['firemaking_xphrs'] = [0]

  EHP_IRON['crafting_tiers'] = [0]
  EHP_IRON['crafting_xphrs'] = [19500]

  # EHP_IRON['smithing_tiers'] = [0, 10050000, 13034000, 154200000]
  # EHP_IRON['smithing_xphrs'] = [8950, 2984000, 8950, 45800000]

  EHP_IRON['smithing_tiers'] = [0]
  EHP_IRON['smithing_xphrs'] = [18350]

  EHP_IRON['mining_tiers'] = [0]
  EHP_IRON['mining_xphrs'] = [0]

  EHP_IRON['runecraft_tiers'] = [0]
  EHP_IRON['runecraft_xphrs'] = [3820]



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
  
  EHP_UIM['prayer_tiers'] = [0]
  EHP_UIM['prayer_xphrs'] = [9300]

  # EHP_UIM['magic_tiers'] = [0, 3973, 247886, 3500000, 13034000, 53700000]
  # EHP_UIM['magic_xphrs'] = [5000, 34800, 51700, 9534000, 51700, 146300000]

  EHP_UIM['magic_tiers'] = [0, 174, 3973, 7842]
  EHP_UIM['magic_xphrs'] = [5000, 15600, 34800, 0]

  # EHP_UIM['cooking_tiers'] = [0, 101333]
  # EHP_UIM['cooking_xphrs'] = [40000, 120000]

  EHP_UIM['cooking_tiers'] = [0]
  EHP_UIM['cooking_xphrs'] = [0]

  # EHP_UIM['woodcutting_tiers'] = [0, 2411, 13363, 41171, 302288, 1986068, 5346332, 13034431, 150000000]
  # EHP_UIM['woodcutting_xphrs'] = [7000, 15000, 28000, 40000, 50000, 60000, 70000, 75000, 78500]

  EHP_UIM['woodcutting_tiers'] = [0, 2411, 13363, 41171, 302288, 1986068, 5346332, 13034431, 150000000]
  EHP_UIM['woodcutting_xphrs'] = [4000, 8500, 16000, 22800, 28500, 34300, 40000, 42850, 78500]

  # EHP_UIM['fishing_tiers'] = [0, 4470, 13363, 273742, 737627, 2500000, 6000000, 13034431, 149000000]
  # EHP_UIM['fishing_xphrs'] = [14000, 28000, 35000, 45000, 55000, 65000, 70000, 75000, 78500]

  EHP_UIM['fishing_tiers'] = [0, 4470, 13363, 273742, 737627, 2500000, 6000000, 13034431, 149000000]
  EHP_UIM['fishing_xphrs'] = [14000, 26700, 33300, 42800, 52400, 61900, 66400, 71400, 78500]

  # EHP_UIM['firemaking_tiers'] = [0, 3858, 21381, 101333]
  # EHP_UIM['firemaking_xphrs'] = [30700, 46100, 69100, 144600]

  EHP_UIM['firemaking_tiers'] = [0]
  EHP_UIM['firemaking_xphrs'] = [0]

  EHP_UIM['crafting_tiers'] = [0] 
  EHP_UIM['crafting_xphrs'] = [19500]

  # EHP_UIM['smithing_tiers'] = [0, 10092000, 13034000, 154850000]
  # EHP_UIM['smithing_xphrs'] = [7650, 2942000, 7650, 45150000]

  EHP_UIM['smithing_tiers'] = [0]
  EHP_UIM['smithing_xphrs'] = [18350]

  EHP_UIM['mining_tiers'] = [0] 
  EHP_UIM['mining_xphrs'] =[0]

  EHP_UIM['runecraft_tiers'] = [0] 
  EHP_UIM['runecraft_xphrs'] = [3820]
  


  # Bonus XP (End): 
  # 0.2500 Smithing:Mining from 0 to 200000000 Mining xp 
  # 1.1350 Magic:Mining from 0 to 200000000 Mining xp 
  # 0.1380 Magic:Woodcutting from 0 to 200000000 Woodcutting xp 
  # 0.1380 Magic:Fishing from 0 to 200000000 Fishing xp 
  
  # Bonus XP (Start): 
  # 0.1071 Prayer:Cooking from 61512 to 200000000 Cooking xp   
  
  # ratio, bonus_for, bonus_from, start_xp, end_xp
  BONUS_XP_REG = [[0.25, "smithing", "mining", 0, 200000000],
                  [1.3425, "cooking", "fishing", 0, 200000000],
                  [1.135, "magic", "mining", 0, 200000000],
                  [0.138, "magic", "woodcutting", 0, 200000000],
                  [0.138, "magic", "fishing", 0, 200000000],
                  ]
                         
  BONUS_XP_IRON = [[0.1071, "prayer", "attack", 4470, 37224],
                   [0.0625, "prayer", "attack", 37224, 737627],
                   [0.0457, "prayer", "attack", 737627, 200000000],
                   [0.1071, "prayer", "strength", 4470, 37224],
                   [0.0625, "prayer", "strength", 37224, 737627],
                   [0.0457, "prayer", "strength", 737627, 200000000],
                   [0.1071, "prayer", "defence", 4470, 37224],
                   [0.0625, "prayer", "defence", 37224, 737627],
                   [0.0457, "prayer", "defence", 737627, 200000000],
                   [0.1071, "prayer", "ranged", 4470, 37224],
                   [0.0625, "prayer", "ranged", 37224, 101333],
                   [0.0457, "prayer", "ranged", 101333, 200000000],
                   # [0.0992, "runecraft", "crafting", 4470, 200000000],
                   [0.2610, "smithing", "crafting", 4470, 200000000],
                   [1.3425, "cooking", "fishing", 0, 200000000],
                   # [0.0274, "woodcutting", "fishing", 4470, 200000000],
                   # [0.0500, "firemaking", "fishing", 4470, 200000000],
                   [1.3333, "firemaking", "woodcutting", 0, 200000000],
                   [1.4133, "magic", "smithing", 0, 200000000],
                   [0.0381, "magic", "crafting", 0, 200000000],
                   [0.2154, "magic", "runecraft", 0, 200000000]
                   ]
                         
  BONUS_XP_UIM = [[0.1071, "prayer", "attack", 4470, 37224],
                  [0.0625, "prayer", "attack", 37224, 737627],
                  [0.0457, "prayer", "attack", 737627, 200000000],
                  [0.1071, "prayer", "strength", 4470, 37224],
                  [0.0625, "prayer", "strength", 37224, 737627],
                  [0.0457, "prayer", "strength", 737627, 200000000],
                  [0.1071, "prayer", "defence", 4470, 37224],
                  [0.0625, "prayer", "defence", 37224, 737627],
                  [0.0457, "prayer", "defence", 737627, 200000000],
                  [0.1071, "prayer", "ranged", 4470, 37224],
                  [0.0625, "prayer", "ranged", 37224, 101333],
                  [0.0457, "prayer", "ranged", 101333, 200000000],
                  [0.2610, "smithing", "crafting", 4470, 200000000],
                  [1.3425, "cooking", "fishing", 0, 200000000],
                  # [0.0274, "woodcutting", "fishing", 4470, 200000000],
                  # [0.0500, "firemaking", "fishing", 4470, 200000000],
                  [1.3333, "firemaking", "woodcutting", 0, 200000000],
                  [1.4133, "magic", "smithing", 0, 200000000],
                  [0.0381, "magic", "crafting", 0, 200000000],
                  [0.2154, "magic", "runecraft", 0, 200000000]
                  ]

  def get_ehp_type(acc_type)
    case acc_type
    when "Reg"
      return EHP_REG
    when "HCIM", "IM"
      return EHP_IRON
    when "UIM"
      return EHP_UIM
    end
  end
end
