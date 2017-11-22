# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path
F2POSRSRanks::Application.configure do
   config.version = "F2P OSRS Ranks v0.4.1a"
   
    config.skills = ["overall", "attack", "strength", "defence", "hitpoints", "ranged", "prayer",
                     "magic", "cooking", "woodcutting", "p2p", "fishing", "firemaking", "crafting",
                     "smithing", "mining", "p2p", "p2p", "p2p", "p2p", "p2p", "runecraft", "p2p", 
                     "p2p", "p2p", "p2p", "p2p", "p2p", "p2p", "p2p", "lms", "p2p", "p2p"]
    
    config.f2p_skills = ["attack", "strength", "defence", "hitpoints", "ranged", "prayer",
                         "magic", "cooking", "woodcutting", "fishing", "firemaking", "crafting",
                         "smithing", "mining", "runecraft"]



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

    config.ehp_iron['cooking_tiers'] = [0]
    config.ehp_iron['cooking_xphrs'] = [0]

    config.ehp_iron['woodcutting_tiers'] = [0, 2411, 13363, 41171, 9800000]
    config.ehp_iron['woodcutting_xphrs'] = [6000, 12000, 24000, 34700, 72000]

    config.ehp_iron['fishing_tiers'] = [0, 4470, 13363, 273742, 737627, 2500000, 6000000, 9600000]
    config.ehp_iron['fishing_xphrs'] = [12000, 22000, 26000, 28000, 30000, 32000, 38000, 72000]

    config.ehp_iron['firemaking_tiers'] = [0]
    config.ehp_iron['firemaking_xphrs'] = [0]

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

    config.ehp_uim['cooking_tiers'] = [0] 
    config.ehp_uim['cooking_xphrs'] = [0]

    config.ehp_uim['woodcutting_tiers'] = [0, 2411, 13363, 41171, 9800000]
    config.ehp_uim['woodcutting_xphrs'] = [6000, 12000, 24000, 34700, 72000]

    config.ehp_uim['fishing_tiers'] = [0, 4470, 13363, 273742, 737627, 2500000, 6000000, 9600000] 
    config.ehp_uim['fishing_xphrs'] = [12000, 22000, 26000, 28000, 30000, 32000, 38000, 72000]

    config.ehp_uim['firemaking_tiers'] = [0]
    config.ehp_uim['firemaking_xphrs'] = [0]

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
