require 'open-uri'

class Player < ActiveRecord::Base
  before_update :register_hcim_death,
    if: Proc.new { |player| player.player_acc_type_was == 'HCIM' \
                            && player.player_acc_type == 'IM' }

  has_many :player_clan_links
  has_many :clans, through: :player_clan_links

  SKILLS = ["attack", "strength", "defence", "hitpoints", "ranged", "prayer",
            "magic", "cooking", "woodcutting", "fishing", "firemaking", "crafting",
            "smithing", "mining", "runecraft", "overall"]

  TIMES = ["day", "week", "month", "year"]

  ACCOUNT_TYPES = %w[Reg IM HCIM UIM]
  ACCOUNT_TYPE_ANCESTORS = {
    UIM: %w[IM Reg],
    HCIM: %w[IM Reg],
    IM: %w[Reg]
  }

  # This is the canonical list of supporter. It is used to generate the list
  # of supporters on both home page and the about us page. It also contains
  # the flair image and other styling applied to supporters names wherever
  # they appear.
  # Adding a new supporter:
  #   1. Add a new entry this list as a hash {name: "supporter_name"}
  #   2. Add an image after their name by adding the key :flair_after
  #   3. Add an image before their  name by adding the key :flair_before
  #   4. Apply arbitrary css by adding the key :other_css
  #   5. If any new images were required, be sure to add them to app/assests/images
  SUPPORTERS = [{name: "Bargan", amount: 290.82, date: "2021-08-30"},
                {name: "Ikiji", amount: 107.28, date: "2018-09-12", flair_after: "flairs/Mystery_box.png"},
                    {name: "a q p IM"},
                {name: "Iron Rwne", amount: 105, date: "2020-12-10", flair_after: "flairs/rwne.png"},
                {name: "Vagae", amount: 100, date: "2019-08-25", flair_after: "flairs/Strange_skull.png"},
                {name: "M00MARCITO", amount: 100, date: "2020-03-24"},
                {name: "Tele Crab", amount: 100, date: "2020-05-24", flair_before: "flairs/dark_crab.png", flair_after: "flairs/crab_claw.png"},
                {name: "Xliff", amount: 100, date: "2022-02-01", flair_after: "flairs/Air_tiara.gif"},
                {name: "Netbook Pro", flair_after: "flairs/malta_flag.png"},
                {name: "tannerdino", amount: 7.69, date: "2018-11-14", flair_after: "items/Mossy_key.png"},
                {name: "Pawz", amount: 79.25, date: "2018-02-01", flair_after: "flairs/rs3helm.png"},
                {name: "Based F2P IM", amount: 70, date: "2019-10-05", flair_after: "IM.png"},
                {name: "GOLB f2p", amount: 75, date: "2021-01-22", flair_before: "flairs/golb_flair1.png", flair_after: "flairs/golb_flair2.png", other_css: ["color: #66ffff"]},
                    {name: "XP go Dididi", amount: 0, date: "2020-12-26", flair_before: "flairs/golb_flair3.jpeg"}, # request of GOLB f2p
                {name: "UIM Gloo", amount: 70, date: "2021-09-02"},
                {name: "Anonymous", amount: 60, date: "2018-01-31", no_link: true},
                {name: "Obor", amount: 60, date: "2018-01-31", flair_before: "flairs/shamanmask.png", flair_after: "flairs/oborclub.png"},
                {name: "XaTaRaX", amount: 60, date: "2020-12-27", flair_after: "flairs/Snare.png"},
                {name: "GameboyMicro", amount: 55, date: "2020-12-10", flair_after: "flairs/Spookier_hood.png"},
                {name: "DJ9", amount: 50, date: "2018-04-18", flair_after: "flairs/73_hitsplat.png"},
                    {name: "cwismis noob", flair_after: "flairs/christmas_tree.png"},
                    {name: "Crawler", flair_after: "flairs/flesh_crawler.png"},
                    {name: "Ticket Farm", date: "2019-07-05", flair_after: "flairs/genie_head.png"},
                    {name: "Wooper", flair_after: "flairs/wooper.png"},
                    {name: "Earfs"},
                {name: "Metan", amount: 50, date: "2019-02-13", flair_after: "flairs/Rune_essence.png"},
                {name: "Freckled Kid", amount: 41.85, flair_after: "flairs/burnt_bones.png"},
                {name: "Romans ch 12", amount: 40, date: "2019-04-13"},
                {name: "Iron of One", amount: 37, date: "2022-01-24", flair_after: "items/Dark_cavalier.png"},
                {name: "Gl4Head", amount: 30, flair_after: "flairs/fighting_boots.png"},
                {name: "Your Bearr", amount: 30, date: "2020-07-21", flair_after: "flairs/Bear_feet.png"},
                    {name: "Bearrable", amount: 30, date: "2020-07-21"}, # request of Your Bearr
                {name: "I-69-Buddha", amount: 30, date: "2020-11-26", flair_before: "flairs/clue_scroll_beginner.png", flair_after: "flairs/demon_feet.png"},
                {name: "minlvlskilla", flair_after: "flairs/3.png"},
                {name: "Hagl", amount: 30, date: "2021-09-26"},
                {name: "Fe F2P", amount: 25, date: "2018-06-21", flair_after: "flairs/skulled.png"},
                {name: "Nun", amount: 25, date: "2020-12-24", flair_after: "skills/prayer.png"},
                {name: "Fordly", amount: 25, date: "2021-01-29", flair_after: "flairs/map.png"},
                {name: "Hc Eudu", amount: 25, date: "2021-02-13", flair_after: "flairs/Lamp.png"},
                {name: "Reichsheini", amount: 25, date: "2021-03-02", flair_after: "flairs/Fire_talisman.png"},
                {name: "Flee2Pray", amount: 25, date: "2021-05-18", flair_after: "flairs/f2pbtw.png", other_css: ["color: #ffc03a"]},
                {name: "uimevan", amount: 25, date: "2022-02-15", flair_after: "flairs/uim_helm.png"},
                {name: "f2p Ello", amount: 22, date: "2021-01-21", flair_after: "flairs/ello_flag.png"},
                {name: "I go by zach", amount: 21, date: "2020-03-12", flair_after: "flairs/Spade.png"},
                    {name: "hey earth", amount: 21, date: "2020-07-09", flair_after: "flairs/yellow_partyhat.png"}, # request from zach
                    {name: "regular zach", amount: 21, date: "2021-02-09", flair_after: "flairs/Reindeer_hat"}, # request from zach
                    {name: "zach gathers", amount: 21, date: "2021-06-21", flair_after: "flairs/Gilded_pickaxe.png"}, # request from zach
                {name: "UIM STK F2P", amount: 20, date: "2018-09-20", flair_after: "items/Rune_scimitar.gif"},
                    {name: "IM 73 COMBAT", amount: 20, date: "2018-09-20", flair_after: "flairs/skulled.png"}, # request of UIM STK F2P
                {name: "vpered", amount: 20, date: "2020-05-20", flair_after: "flairs/russia_flag.png"},
                {name: "Anonymous", amount: 20, date: "2019-07-19", no_link: true},
                {name: "seid", amount: 20, date: "2019-11-18"},
                {name: "Zubat", amount: 20, date: "2019-12-02", flair_after: "flairs/zubat.png", other_css: ["color: #8BB4EE"]},
                {name: "Varvali", amount: 20, date: "2020-05-12"},
                {name: "Ywal", amount: 20, date: "2020-06-03", flair_after: "flairs/ywal.png", other_css: ["color: #C9AD79"]},
                {name: "Tramali", amount: 20, date: "2020-07-11", flair_after: "flairs/fire_strike.png"},
                {name: "Laskati", amount: 20, date: "2020-12-27", flair_after: "flairs/wise_old_man.png"},
                {name: "FishToBond", amount: 20, date: "2021-01-16", flair_after: "flairs/Raw_swordfish.png"},
                {name: "PeteyMcFly", amount: 20, date: "2021-02-10", flair_after: "flairs/PeteyMcFly.png"},
                {name: "15rubydream", amount: 20, date: "2021-08-09", flair_after: "items/Uncut_ruby.gif"},
                {name: "C00MQUEEN", amount: 20, date: "2021-09-02"},
                {name: "7x420", amount: 20, date: "2021-09-04", flair_after: "flairs/flag_estonia.gif"},
                {name: "Gocelin", amount: 20, date: "2021-12-31", flair_after: "flairs/genie.png", "other_css": ["color: #2E96FB"]},
                {name: "Halcyon Seed", amount: 20, date: "2022-02-20", flair_after: "flairs/strange_plant.png"},
                {name: "TrustNoBanks", amount: 18, date: "2021-03-06", flair_after: "flairs/Green_halloween_mask.png", other_css: ["color: #0e7912"]},
                {name: "Xan So", amount: 15, date: "2018-11-13", flair_after: "items/Maple_shortbow.png"},
                {name: "ColdFingers3", amount: 15, date: "2019-04-29", flair_after: "flairs/Snow_imp_gloves.png"},
                {name: "Brim haven", amount: 15, date: "2019-05-31", flair_after: "flairs/ceres.png"},
                {name: "Anonymous", amount: 15, date: "2019-10-12", no_link: true},
                {name: "HCIM_btw_fev", amount: 15, date: "2020-08-01", flair_after: "flairs/kitten.png", other_css: ["color: #800080"]},
                {name: "Vanity Pride", amount: 15, date: "2020-10-30", flair_after: "flairs/Blue_partyhat.png"},
                {name: "MrSoda70", amount: 15, date: "2021-03-28", flair_after: "flairs/Potion.png"},
                {name: "Schwifty Bud", amount: 15, date: "2021-08-06", flair_after: "flairs/rick_sanchez.png", other_css: ["font-family: Script", "font-variant: small-caps"]},
                {name: "Iron Gige", amount: 15, date: "2021-09-01", flair_after: "items/Rune_battleaxe.gif"},
                {name: "Solo Emperor", amount: 15, date: "2021-09-08", flair_after: "flairs/Bucket_of_milk.png"},
                {name: "AKPigsley", amount: 15, date: "2021-10-25"},
                {name: "Ghost Bloke", amount: 13, date: "2018-12-13", flair_after: "flairs/ghost_bloke.png"}, # subtract $2 out of original $10 for paying for rights to flair image ;_;
                    {name: "Aus Flash", amount: 13, date: "2021-02-03", flair_after: "flairs/australia-flag.png"}, # request of Ghost Bloke
                {name: "jyozf", amount: 12.30, date: "2020-07-15", flair_after: "items/Maple_shortbow.png"},
                {name: "Ll0y d", amount: 11.79, date: "2021-08-16", other_css: ["color: #FCCD12"]},
                {name: "Yewsless", amount: 11, date: "2018-03-11", flair_after: "items/Yew_logs.gif"},
                {name: "F2P Lukie", amount: 10, date: "2018-01-31", flair_after: "flairs/tea.png"},
                {name: "Tame My Wild", amount: 10, date: "2018-02-06", flair_after: "flairs/dog.png"},
                {name: "Faij", amount: 10, date: "2018-03-06", flair_after: "flairs/frog.png"},
                {name: "Frogmask", flair_after: "flairs/frog.png"},
                {name: "FitMC", amount: 10, date: "2018-03-13", flair_after: "flairs/anchovy_pizza.png"},
                {name: "Pink skirt", amount: 10, date: "2018-05-18", flair_after: "flairs/pink_skirt.png"},
                {name: "Tagoodness", amount: 10, date: "2018-11-15", flair_after: "items/Diamond.gif"},
                {name: "NoQuestsHCIM", amount: 10, date: "2018-12-02", flair_after: "flairs/noquest.png"},
                {name: "Sir BoJo", amount: 10, date: "2018-12-03", flair_after: "items/Rune_mace.gif"},
                {name: "Sad Jesus", amount: 10, date: "2019-01-19", flair_after: "flairs/sad_jesus.png"},
                {name: "Cas F2P HC", amount: 10, date: "2019-01-30", flair_after: "items/Big_bones.gif"},
                {name: "UIM Dakota", amount: 10, date: "2019-02-26", flair_after: "flairs/Cadava_berries.png"},
                {name: "F2P Jords", amount: 10, date: "2019-03-17", flair_after: "flairs/Druidic_wreath.png"},
                {name: "Feature", amount: 10, date: "2019-14-04", flair_after: "flairs/camel.png"},
                {name: "Steel Afro", amount: 10, date: "2019-05-16"},
                {name: "UIM TMW", amount: 10, date: "2019-07-19"},
                {name: "Bonk Loot", amount: 10, date: "2019-08-27", flair_after: "flairs/Amulet_of_power.png"},
                {name: "iron korbah", amount: 10, date: "2019-09-27"},
                {name: "ASCMA2828Z", amount: 10, date: "2019-11-16", flair_after: "flairs/Earth_rune.png"},
                {name: "Exile Myth", amount: 10, date: "2019-12-23", flair_after: "flairs/cwars_gold_helm.png"},
                {name: "F2P_Poke_Btw", amount: 10, date: "2020-01-12"},
                {name: "SmellyPooo", amount: 10, date: "2020-02-14"},
                {name: "Solo Tricket", amount: 10, flair_after: "flairs/Jester_cape.png"},
                {name: "Gem Shop", amount: 10, flair_after: "items/Ruby.gif"},
                {name: "f2p HClM btw", amount: 10, date: "2020-04-07", flair_after: "flairs/Mole_slippers.png"},
                {name: "Hnn 40", amount: 10, date: "2020-04-08", flair_after: "items/Rune_scimitar.gif", other_css: ["color: #850000"]},
                {name: "Ultimate F2P", amount: 10, date: "2020-04-10", flair_after: "flairs/Mole_slippers.png"},
                {name: "Don Rinus", amount: 10, date: "2020-04-26", flair_after: "flairs/Shoulder_parrot.png"},
                {name: "water9", amount: 10, date: "2020-05-01", flair_after: "flairs/Earth_talisman.gif"},
                {name: "BigFootTall", amount: 10, date: "2020-06-16", flair_after: "flairs/BigFootTall.png"},
                {name: "Jato Lava", amount: 10, date: "2020-06-27", flair_after: "flairs/brazil_flag.png"},
                {name: "Wqve Racer", amount: 10, date: "2020-07-02", flair_after: "flairs/yellow_partyhat.png"},
                {name: "HC Pimps", amount: 10, date: "2020-07-03", flair_after: "flairs/wizards_mind_bomb.png", other_css: ["color: pink"]},
                {name: "Wopski", amount: 10, date: "2020-07-12", flair_after: "flairs/penguin.png"},
                {name: "Jambo3547", amount: 10, date: "2020-07-21", flair_after: "flairs/black_cat.png"},
                {name: "Pokebaw", amount: 10, date: "2020-08-14", flair_after: "flairs/pokeball.png"},
                {name: "BlueGainz", amount: 10, date: "2020-08-17", flair_after: "flairs/BlueGainz.png"},
                {name: "BTW F2P HCIM", amount: 10, date: "2020-08-25", flair_before: "HCIM.png", flair_after: "flairs/horus.png", other_css: ["color: #850000"]},
                    {name: "FE F2P PURE", amount: 10, date: "2020-08-25", flair_before: "IM.png", flair_after: "flairs/Stale_baguette.png", other_css: ["color: #969696"]}, # same request as BTW F2P HCIM

                # i don't really know how much is "50% of proceeds goes to F2P.wiki" via Pawz's F2P.wiki merch
                # but let's just call it a $10 donation and put those requests here
                {name: "Pinai", amount: 10, date: "2020-11-04", other_css: ["color: #00ff00"]},

                {name: "Asura Zoma", amount: 10, date: "2020-12-17", flair_after: "flairs/Unstrung_symbol.png"},
                {name: "re-fine", amount: 10, date: "2021-02-12", flair_after: "flairs/Mask_of_balance.png"},
                {name: "Astrodeo", amount: 10, date: "2021-02-12", flair_after: "flairs/NASA-logo.png"},
                {name: "f meinen", amount: 10, date: "2021-03-13", flair_after: "flairs/gengar.png"},
                {name: "TheNutSlush", amount: 10, date: "2021-05-09", flair_after: "flairs/Body_rune.png"},
                {name: "Arceus HC", amount: 10, date: "2021-05-20", flair_after: "flairs/Amulet_of_defence_t.png"},
                {name: "F2p_MrStark", amount: 10, date: "2021-06-25", flair_after: "flairs/LFC.png"},
                {name: "Whypay2play", amount: 10, date: "2021-08-02", flair_after: "flairs/bunny_ears.png"},
                {name: "S1lentSpirit", amount: 10, date: "2021-08-23", flair_after: "flairs/Black_partyhat.png"},
                {name: "EyeUrnZek", amount: 10, date: "2021-09-25"},
                {name: "PlNKlE", amount: 10, date: "2021-10-29", flair_after: "flairs/bunny_ears.png", other_css: ["color: #DF06B5"]},
                {name: "cest parti", amount: 10, date: "2021-11-08", flair_after: "flairs/Hitpoints_icon.png"},
                {name: "Kotsumi", amount: 10, date: "2021-11-25", flair_after: "flairs/kotsumi.png"},
                {name: "F2p Menacing", amount: 10, date: "2021-12-08", flair_after: "flairs/30x30cro.png"},
                {name: "Zaadkameraad", amount: 10, date: "2021-12-18", flair_after: "flairs/Black_santa_hat.png", other_css: ["color: rgb(232, 232, 229)"]},
                {name: "Jazzwagons", amount: 10, date: "2021-12-31", flair_after: "flairs/Music.png"},
                {name: "Kebab Norsu", amount: 10, date: "2022-02-21", flair_before: "flairs/Kebab.png", flair_after: "UIM.png"},
                {name: "n0neshine", amount: 5, date: "2021-06-12", flair_after: "flairs/n0neshine.png"},
                {name: "Swiss Corona", amount: 8, date: "2020-11-06", flair_after: "flairs/switzerland_flag.png", other_css: ["color: #FF0000"]},
                {name: "For Ulven", amount: 7.77, date: "2018-03-11", flair_after: "flairs/wolf.png"},
                {name: "Fe Apes", amount: 7.69, date: "2018-12-14", flair_after: "flairs/fe_apes.jpg"},
                {name: "Im Ronin BTW", amount: 7.5, date: "2020-05-17"},
                {name: "Playing Fe", amount: 7, date: "2018-04-26", flair_after: "flairs/salmon.png"},
                {name: "MOL3 M4STER", amount: 6.90, date: "2022-01-18", flair_after: "flairs/Ring_of_kinship.png"},
                {name: "ZINJAN", amount: 6.66, date: "2018-05-18", flair_after: "flairs/ZINJANTHROPI.png"},
                {name: "Snooz Button", amount: 6.66, date: "2018-06-03", flair_after: "flairs/macaroni.png"},
                {name: "Ir0n K0b0ld", amount: 6.66, date: "2021-01-02", flair_after: "flairs/Red_salamander.png"},
                {name: "Valleyman6", amount: 6.64, date: "2018-06-15", flair_after: "flairs/uk_flag.png"},
                {name: "i drink fiji", amount: 6, date: "2018-05-06", flair_after: "flairs/blue_cape.png"},
                {name: "5th Teletuby", amount: 6, date: "2020-03-29", flair_after: "flairs/Easter_basket.png"},
                {name: "Uxeef", amount: 5.96, date: "2018-09-17"},
                {name: "Lilypad19", amount: 5.69, date: "2020-01-23"},
                {name: "UltLoser BTW", amount: 5.69, date: "2021-11-10", flair_after: "flairs/Max_cape.png"},
                {name: "iballer225", amount: 5.69, date: "2021-11-14", flair_after: "flairs/key_infinity.png"},
                {name: "Adentia", amount: 5.55, date: "2018-12-03", flair_after: "flairs/danish_flag.png"},
                {name: "threewaygang"},
                {name: "hardcorerf2p", amount: 5.55, date: "2021-02-06", flair_after: "flairs/goblin.png", other_css: ["color: #E59E1C"]},
                {name: "Yellow bead", amount: 5.38, date: "2018-05-02", flair_after: "flairs/yellow_bead.png"},
                {name: "Borads f2p", amount: 5.10, date: "2020-11-14", flair_after: "flairs/ruby_ring.png"},
                {name: "70 Crafting", amount: 5.08, date: "2020-05-06", flair_after: "flairs/diamond_amulet_u.png"},
                {name: "IronMace Din", amount: 5, date: "2018-02-18", flair_after: "flairs/maceblur2.png"},
                {name: "citnA", amount: 5, date: "2018-02-06", flair_after: "flairs/bronzehelm.png"},
                {name: "Lea Sinclair", amount: 5, date: "2018-02-09", flair_after: "flairs/cupcake.png"},
                {name: "lRAIDERSS", amount: 5, date: "2018-02-10", flair_after: "flairs/raiders3.png"},
                {name: "Sofacanlazy", amount: 5, date: "2018-02-11", flair_after: "flairs/australia-flag.png"},
                {name: "I love rs", amount: 5, date: "2018-02-18", flair_after: "flairs/tank.png"},
                {name: "Say F2p Ult", amount: 5, date: "2018-03-01", flair_after: "flairs/santa.png"},
                {name: "Irish Woof", amount: 5, date: "2018-03-04", flair_after: "flairs/leprechaun2.png"},
                {name: "Leftoverover", amount: 5, date: "2018-04-04", flair_after: "flairs/rope.png"},
                {name: "Drae", amount: 5, date: "2018-05-08", flair_after: "flairs/rsz_dshield.png"},
                {name: "David BBQ", amount: 5, date: "2018-05-18", flair_after: "flairs/cooked_chicken.png"},
                {name: "UI Pain", amount: 5, date: "2018-06-10", flair_after: "flairs/steel_axe.png"},
                {name: "Bronze axxe", amount: 5, date: "2020-03-12", flair_after: "flairs/Bronze_axe.png"},
                {name: "oLd Sko0l", amount: 5, date: "2018-09-16"},
                {name: "WishengradHC", amount: 5, date: "2018-10-23", flair_after: "flairs/bowser.png"},
                {name: "n4ckerd", amount: 5, date: "2018-11-17", flair_after: "items/Gilded_med_helm.png"},
                {name: "InsurgentF2P", amount: 5, date: "2019-01-01", flair_after: "skills/defence.png"},
                {name: "SapphireHam", amount: 5, date: "2019-01-11", flair_after: "items/Coal.gif"},
                {name: "Doublessssss", amount: 5, date: "2019-01-12"},
                {name: "xmymwf609", amount: 5, date: "2019-01-24"},
                {name: "Onnn", amount: 5, date: "2019-02-03", flair_after: "flairs/canada-flag.png"},
                {name: "Shade_Core", date: "2019-02-08", amount: 5, flair_after: "flairs/shade_core.png"},
                {name: "F2P UIM OREO", amount: 5, date: "2019-02-18", flair_after: "flairs/f2p_uim_oreo.jpg"},
                {name: "HCBown", amount: 5, date: "2019-03-04"},
                {name: "Dukeddd", amount: 5, date: "2019-03-06"},
                {name: "one a time", amount: 5, date: "2019-03-06"},
                {name: "DansPotatoe", date: "2019-03-13", flair_after: "items/Potato.png"},
                {name: "Wizards Foot", amount: 5, date: "2019-03-15", flair_after: "flairs/Wizards_Foot_flair.png"},
                {name: "Hardcore VFL", amount: 5, date: "2019-03-23", flair_after: "HCIM.png"},
                {name: "Pizzarrhea", amount: 5, date: "2019-03-23", flair_after: "flairs/pizzarrhea.gif"},
                {name: "bemanisows", amount: 5, date: "2019-03-26", flair_after: "flairs/vannaka.png"},
                {name: "Dusty Lime", amount: 5, date: "2019-03-27", flair_after: "items/Rune_chainbody.gif"},
                {name: "Brantrout", amount: 5, date: "2019-04-02", flair_after: "items/Trout.gif"},
                {name: "f2p uim nerd", amount: 5, date: "2019-04-09"},
                {name: "Arizer Air", amount: 5, date: "2019-04-15", flair_after: "flairs/chicken_wing.png"},
                {name: "Irondish", amount: 5, date: "2019-04-20", flair_after: "flairs/egg.png"},
                {name: "Maze", amount: 5, date: "2019-04-21", flair_after: "flairs/mysterious.png"},
                {name: "P1J", amount: 5, date: "2019-04-23"},
                {name: "the f2p uim", amount: 5, date: "2019-04-26", flair_after: "flairs/Green_partyhat.png"},
                {name: "Kill the Ego", amount: 5, date: "2019-05-12"},
                {name: "BALN", amount: 5, date: "2019-05-16"},
                {name: "Kristelee", amount: 5, date: "2019-06-26"},
                {name: "Politiken", amount: 5, date: "2019-06-30", flair_after: "flairs/danish_flag.png"},
                {name: "UIMfreebie", amount: 5, date: "2019-08-24", flair_after: "flairs/Fancy_boots.png"},
                {name: "jane uwu", amount: 5, date: "2019-08-28", flair_after: "flairs/Dutch_flag.png"},
                {name: "ginormouskat", amount: 5, date: "2019-09-28"},
                {name: "Kankahboef", amount: 5, date: "2019-10-18", flair_after: "flairs/thieving.png"},
                {name: "Aquaruim", amount: 5, date: "2019-10-23"},
                {name: "sexychocolat", amount: 5, date: "2019-11-04", flair_after: "flairs/Chocolate_bar.png"},
                {name: "thejinjoking", amount: 5, date: "2019-11-20"},
                {name: "Anonymous", amount: 5, date: "2019-11-25", no_link: true},
                {name: "ThaneCore", amount: 5, date: "2019-12-08"},
                {name: "a hokie", amount: 5, date: "2019-12-21", flair_after: "flairs/hokie.png"},
                {name: "Futile_Me", amount: 5, date: "2019-12-24", flair_after: "flairs/panda.png"},
                {name: "Firebolt8xp", amount: 5, date: "2019-12-30", flair_after: "skills/mining.png"},
                {name: "King Dumile", amount: 5, date: "2020-01-02", flair_after: "flairs/antisanta.png"},
                {name: "celastri", amount: 5, date: "2020-01-16"},
                {name: "Iron Zephrya", amount: 5, date: "2020-01-20"},
                {name: "Nereid", amount: 5, date: "2020-01-25"},
                {name: "PureF2pBlue", amount: 5, date: "2020-01-30"},
                {name: "Fwips", amount: 5, date: "2020-02-02", flair_after: "flairs/Yin_yang_amulet.png"},
                {name: "ironwind397", amount: 5, date: "2020-02-13"},
                {name: "thelast lvl", amount: 5, date: "2020-02-29", flair_after: "items/Iron_bar.gif"},
                {name: "Marrio III", amount: 5, date: "2020-02-29"},
                {name: "Prof Zetlin", amount: 5, date: "2020-03-21", flair_after: "flairs/Shoulder_parrot.png"},
                {name: "R E3", amount: 5, date: "2020-03-24"},
                {name: "Plue", amount: 5, date: "2020-04-06", flair_after: "flairs/Snow_globe.png"},
                    # plue
                    {name: "Fixif", amount: 0, date: "2020-04-06"},
                {name: "Solo Dancer", amount: 5, date: "2020-04-15", flair_after: "flairs/Redemption.png"},
                {name: "maddiefsna5", amount: 5, date: "2020-04-23", no_link: true},
                {name: "Ultw", amount: 5, date: "2020-04-28"},
                {name: "xxcxzx", amount: 5, date: "2020-05-05"},
                {name: "iTz a Loner", amount: 5, date: "2020-05-16", flair_after: "flairs/barricade.png"},
                {name: "Momoka Nishi", amount: 5, date: "2020-05-27", flair_after: "flairs/red_boater.png"},
                {name: "HCIM Keeper", amount: 5, date: "2020-05-31"},
                {name: "Covid 19 V2", amount: 5, date: "2020-06-10", flair_after: "flairs/virus_small.png", flair_before: "flairs/HCIM.png", other_css: ["color: #990000"]},
                {name: "Hierro Hero", amount: 5, date: "2020-06-17"},
                {name: "Raytheons", amount: 5, date: "2020-06-20"},
                {name: "Cx or xD", amount: 5, date: "2020-06-29", flair_after: "flairs/finland_flag.png"},
                {name: "FreeFromBank", amount: 5, date: "2020-07-21", flair_after: "flairs/new_zealand_flag.png"},
                {name: "xX360n0sc0pe", amount: 5, date: "2020-07-29", flair_after: "flairs/rune_pickaxe.png"},
                {name: "Wildy willy", amount: 5, date: "2020-07-30", flair_after: "flairs/skull.png"},
                {name: "Mini Catable", amount: 5, date: "2020-08-02", flair_after: "flairs/Reindeer_hat.png"},
                {name: "Break My Ego", amount: 5, date: "2020-08-18"},
                {name: "Evangelion", amount: 5, date: "2020-08-27", flair_after: "flairs/team-cape-40.png"},
                {name: "SkyraHC", amount: 5, date: "2020-08-29", flair_after: "flairs/rune_scimitar_zamorak.png"},
                {name: "Mr Leong", amount: 5, date: "2020-09-11", flair_after: "flairs/sloth.png"},
                {name: "doug 1634", amount: 5, date: "2020-10-15", flair_after: "flairs/beer.png", other_css: ["color: #0078ff"]},
                {name: "sevelius", amount: 5, date: "2020-11-13"},
                {name: "hard_d0ng", amount: 5, date: "2020-11-25", flair_after: "flairs/rune_med_helm.png"},
                {name: "DopeAssF2p", amount: 5, date: "2020-11-28", flair_after: "flairs/Amulet_of_power.png"},
                {name: "Ironthokk", amount: 5, date: "2020-12-01", flair_after: "flairs/Maple_shortbow.png"},
                {name: "Kev F2P", amount: 5, date: "2020-12-28", flair_after: "flairs/bunny_ears.png"},
                {name: "F2P Verf", amount: 5, date: "2020-12-30", flair_after: "flairs/Dutch_flag.png"},
                {name: "dhbs", amount: 5, date: "2021-01-04", flair_after: "flairs/white_partyhat.png"},
                {name: "Yvn", amount: 5, date: "2021-01-08", flair_after: "flairs/willow.png"},
                {name: "mythiclime", amount: 5, date: "2021-01-10", flair_after: "items/Adamantite_bar.gif"},
                {name: "Reviloekul", amount: 5, date: "2021-01-13", flair_after: "flairs/Black_hween_mask.png"},
                {name: "SYNTHETlX", amount: 5, date: "2021-01-22", flair_after: "flairs/SYNTHETlX.png", other_css: ["color: #01D1FE"]},
                {name: "WeldingIM", amount: 5, date: "2021-01-26", flair_after: "flairs/estonia_flag.png"},
                {name: "Swiss Ebola", amount: 5, date: "2021-01-30", flair_after: "flairs/switzerland_flag.png", other_css: ["color: #FFFFFF"]},
                {name: "8copper69", amount: 5, date: "2021-02-06", flair_after: "flairs/hammer.png"},

                # gift of UFCFAN47 in w_385 discord
                {name: "GratisSpil", amount: 5, date: "2021-02-08", flair_after: "skills/mining.png"},

                {name: "Reclinant", amount: 5, date: "2021-02-09", flair_after: "flairs/UIM.png", other_css: ["color: white"]},
                {name: "azn rick", amount: 5, date: "2021-03-02", flair_after: "flairs/3030.png"},
                {name: "IronMan4Free", amount: 5, date: "2021-02-15", flair_after: "flairs/flippa.png"},
                {name: "wytchblades", amount: 5, date: "2021-03-08", flair_after: "flairs/Red_halloween_mask.png"},
                {name: "Xxjx", amount: 5, date: "2021-03-21", flair_after: "flairs/rune_med_helm.png"},
                {name: "boneyghost", amount: 5, date: "2021-03-25", flair_after: "flairs/Bones.png"},
                {name: "Rykkirs", amount: 5, date: "2021-03-26", flair_after: "flairs/Inverted_santa_hat.png"},
                {name: "Rooie UIM", amount: 5, date: "2021-03-27"},
                {name: "RuneOrWalk", amount: 5, date: "2021-04-01", flair_after: "flairs/Runecraft_icon.png"},
                {name: "UIM Lag", amount: 5, date: "2021-04-04", flair_after: "flairs/rune_scimitar_zamorak.png"},
                {name: "Survender", amount: 5, date: "2021-04-22", flair_after: "flairs/Survender.png"},
                {name: "FE Kaitios", amount: 5, date: "2021-04-22", flair_after: "flairs/FE_Kaitios.png"},
                {name: "Kenneth760", amount: 5, date: "2021-04-25", flair_after: "flairs/white_partyhat.png"},
                {name: "tneuqolitluM", amount: 5, date: "2021-05-19", flair_after: "flairs/Burnt_meat.png"},
                {name: "IownFarah", amount: 5, date: "2021-05-22"},
                {name: "Twink Skills", amount: 5, date: "2021-05-27", flair_after: "flairs/Strength_amulet_t.png"},
                {name: "reubengonz", amount: 5, date: "2021-05-30", flair_after: "flairs/Pet_cat_grey_and_blue.png"},
                {name: "F2PUIM Mkoll", amount: 5, date: "2021-05-31", flair_after: "flairs/Killers_knife.png"},
                {name: "i Picard", amount: 5, date: "2021-06-07", flair_after: "flairs/i_Picard.png"},
                {name: "TexWasabi", amount: 5, date: "2021-07-04"},
                {name: "MoleSlippers", amount: 5, date: "2021-07-12", flair_after: "flairs/Mole_slippers.png"},
                {name: "W indow", amount: 5, date: "2021-07-15", flair_after: "flairs/Adamant_axe.png", other_css: ["color: #0072ff"]},
                {name: "Grumpy Ag", amount: 5, date: "2021-07-25"},
                {name: "W00H000", amount: 5, date: "2021-09-04",other_css: ["color: #9933ff"]},
                {name: "railwayspike", amount: 5, date: "2021-09-14", flair_after: "flairs/Steel_nails.png"},
                {name: "chiri uwu", amount: 5, date: "2021-09-19", flair_after: "flairs/Orange_cape.png"},
                {name: "Morghurassor", amount: 5, date: "2021-10-19", flair_after: "flairs/Type_O_Negative_logo.jpg"},
                {name: "f2fish", amount: 5, date: "2021-11-08", flair_after: "flairs/f2fish.png"},
                {name: "All La Glory", amount: 5, date: "2021-11-21", flair_after: "flairs/All_La_Glory.png"},
                {name: "MuddyStreets", amount: 5, date: "2021-11-28"},
                {name: "im fe f2p", amount: 5, date: "2021-11-30", flair_after: "flairs/im_fe_f2p.png"},
                {name: "Pxri", amount: 5, date: "2021-12-31", flair_after: "flairs/Zombie_head.png"},
                {name: "IM nicaddict", amount: 5, date: "2022-02-03"},
                {name: "Nqgo", amount: 5, date: "2022-02-15", flair_after: "flairs/juggernaut.png", other_css: ["color: white"]},
                {name: "njitnelav91", amount: 5, date: "2022-02-25", flair_after: "flairs/anvil.png"},
                {name: "96puppyhunt", amount: 3, date: "2021-07-29", flair_after: "flairs/puppyhunt.png"},
                {name: "Tohno1612", amount: ??, flair_after: "flairs/addy_helm.png"},
                {name: "H C Gilrix", amount: 2.5, date: "2018-03-04", flair_after: "flairs/HCIM.png"},
                {name: "Anonymous", amount: 2.5, date: "2018-07-26", no_link: true},
                {name: "Hratli", amount: 2.5, date: "2020-07-29"},
                {name: "Roavar", amount: 1.5, date: "2019-08-14", flair_after: "flairs/roavar.png"},
                {name: "ColdFingers1", amount: 1, date: "2019-01-15", flair_after: "flairs/ColdFingers1.png"},
                {name: "Anonymous", amount: 1, date: "2019-12-08", no_link: true},
                {name: "HCaliaszeven", amount: 1, date: "2020-01-22"},
                {name: "pussyexpert9", amount: 1, date: "2020-02-03"},
                {name: "goyard purse", amount: 1, date: "2021-09-12"},
                {name: "Useless Knob", amount: 1, date: "2021-11-11"},
                {name: "5perm sock"},
                {name: "HC Yiffer"}, # pro bono tracking
                {name: "Disenthral"}, # pro bono tracking
                {name: "Jingle Bells", flair_after: "flairs/santa.png"}, # devs are allowed their own customizations
                {name: "Ironman260", flair_after: "skills/defence.png"},
              ]
    
  CONTRIBUTORS = [{name: "Tannerdino"},
                {name: "Pawz"},
                {name: "Freckled Dad"},
                {name: "Terrathrone"},
                {name: "UncleTomas"},
                {name: "oooosonasty"},
                {name: "Quadrant Dub"},
              ]


  def self.skills()
    SKILLS
  end

  def self.times()
    TIMES
  end

  def self.supporters_hashes()
    SUPPORTERS
  end

  def self.supporters()
    SUPPORTERS.map{|supporter| supporter[:name]}
  end

  def self.contributors_hashes()
    CONTRIBUTORS
  end

  def self.contributors()
    CONTRIBUTORS.map{|contributor| contributor[:name]}
  end

  def self.account_types
    ACCOUNT_TYPES
  end

  def self.account_type_ancestors
    ACCOUNT_TYPE_ANCESTORS
  end

  def self.sql_supporters()
    quoted_names = supporters.map{ |name| "'#{name}'" }
    "(#{quoted_names.join(",")})"
  end

  def self.sql_contributors()
    quoted_names = contributors.map{ |name| "'#{name}'" }
    "(#{quoted_names.join(",")})"
  end

  # The characters +, _, \s, -, %20 count as the same when doing a lookup on hiscores.
  def self.sanitize_name(str)
    if str.downcase == "_yrak"
      return str
    else
      str = ERB::Util.url_encode(str).gsub(/[-_\\+]|(%20)|(%C2%A0)/, " ")
      return str.gsub(/\A[^A-z0-9]+|[^A-z0-9\s\_-]+|[^A-z0-9]+\z/, "")
    end
  end

  def self.find_player(id)
    id = self.sanitize_name(id)
    splits = id.split(/[\s\_]|(%20)/)
    res = splits.join("_") # _ is a wildcard
    player = Player.where("lower(player_name) like '%#{res.downcase}%' and length(player_name) = length('#{res.downcase}')").first

    if player.nil?
      begin
        player = Player.find(Float(id))
      rescue
        return false
      end
    end
    return player
  end

  def url_friendly_player_name
    ERB::Util.url_encode(player_name).gsub(/(%C2)*%A0/, '_')
  end

  def hcim_dead?
    # Skip check for UIMs who can never have been HCIMs.
    return false if player_acc_type == 'UIM'

    Hiscores.hcim_dead?(player_name)
  end

  def calc_combat(stats_hash)
    att = stats_hash["attack_lvl"]
    str = stats_hash["strength_lvl"]
    defence = stats_hash["defence_lvl"]
    hp = stats_hash["hitpoints_lvl"]
    ranged = stats_hash["ranged_lvl"]
    magic = stats_hash["magic_lvl"]
    pray = stats_hash["prayer_lvl"]

    base = 0.25 * (defence + hp + (pray/2).floor)
    melee = 0.325 * (att + str)
    range = 0.325 * ((ranged/2).floor + ranged)
    mage = 0.325 * ((magic/2).floor + magic)
    combat = (base + [melee, range, mage].max).round(5)

    if combat < 3.4
      combat = 3.4
    end

    stats_hash["combat_lvl"] = combat
    return stats_hash
  end

  def get_ehp_type
    case player_acc_type
    when "Reg"
      ehp = F2POSRSRanks::Application.config.ehp_reg
    when "HCIM", "IM"
      ehp = F2POSRSRanks::Application.config.ehp_iron
    when "UIM"
      ehp = F2POSRSRanks::Application.config.ehp_uim
    end
  end

  def remove_cutoff(stats_hash)
    if stats_hash["overall_ehp"] < 1
      Player.where(player_name: player_name).destroy_all
      return true
    end
  end

  def update_player(stats: nil)
    if F2POSRSRanks::Application.config.downcase_fakes.include?(player_name.downcase) || F2POSRSRanks::Application.config.downcase_banned.include?(player_name.downcase)
      Player.where(player_name: player_name).destroy_all
    end
    Rails.logger.info "Updating #{player_name}"

    # save this value first, because any changes to a record will update Rails models' "updated_at"
    last_updated = self.read_attribute("updated_at")

    # Skip fetching from hiscores if stats are provided in parameters.
    unless stats
      begin
        stats, account_type = Hiscores
          .fetch_stats_by_acc(player_name, player_acc_type)
      rescue SocketError, Net::ReadTimeout
        Rails.logger.warn "#{player_name}'s hiscores retrieval failed"
        # Stats could not be fetched due to inresponsiveness (3 attempts).
        return false
      end

      unless stats
        if failed_updates.nil? or failed_updates < 1
          update(failed_updates: 1)
        else
          update(failed_updates: failed_updates + 1)
          update(potential_p2p: 1) if failed_updates > 10
        end
        return false
      end

      if stats === false
        return false
      end

      check_p2p_stats(stats)

      stats[:failed_updates] = 0

      # Temporarily disable auto account detection due to recent Jagex API outages
      # which result in false de-irons or other false account type changes.
      #
      # if player_acc_type != account_type
      #   stats[:player_acc_type] = account_type
      # elsif player_acc_type == 'HCIM' && account_type == 'HCIM' && hcim_dead?
      #   # Check if HCIM has died on the overall hiscores table.
      #   # Normally this should have been picked up by the `fetch_stats`
      #   # call, but this is sometimes not reliable.
      #   stats[:player_acc_type] = 'IM'
      # end
    end

    stats = calculate_virtual_stats(stats, last_updated=last_updated)
    stats[:updated_at] = Time.now

    self.attributes = stats
    self.save(validate: false)
  end

  def force_update_acc_type
    begin
      actual_stats, account_type = Hiscores.fetch_stats(player_name)
    rescue SocketError, Net::ReadTimeout
      Rails.logger.warn "#{player_name}'s hiscores retrieval failed"
      # Stats could not be fetched due to inresponsiveness (3 attempts).
      return false
    end

    return false unless account_type

    if player_acc_type != account_type
      if overall_xp_year_start
        ehp_diffs = get_gains_ehp_diffs()
        update_attribute(:player_acc_type, account_type)
        fix_wrong_acc_type_gains_and_records(actual_stats, ehp_diffs)
      else
        update_attribute(:player_acc_type, account_type)
      end
    elsif player_acc_type == 'HCIM' && account_type == 'HCIM' && hcim_dead?
      # Check if HCIM has died on the overall hiscores table.
      # Normally this should have been picked up by the `fetch_stats`
      # call, but this is sometimes not reliable.
      return update_attribute(:player_acc_type, 'IM')
    end

    true
  end

  def get_gains_ehp_diffs
    # gains and records are based on current EHP minus start EHP (day/week etc).
    # make sure that we save this difference, because changed acc type
    # will very likely result in different current EHP but not the start EHP.
    ehp_diffs = {}
    SKILLS.each do |skill|
      ehp = self.read_attribute("#{skill}_ehp")
      TIMES.each do |time|
        start_ehp = self.read_attribute("#{skill}_ehp_#{time}_start")
        ehp_diff = ehp - start_ehp
        ehp_diffs["#{skill}_ehp_#{time}"] = [ehp_diff, 0].max
      end
    end

    return ehp_diffs
  end

  def fix_wrong_acc_type_gains_and_records(actual_stats, ehp_diffs)
    # get the new current EHP after updating the player acc type
    stats = calculate_virtual_stats(actual_stats)

    # finally, set the correct #{SKILL}_ehp_#{TIME}_start so that gains and
    # records will display the correct, same amount as before the acc_type update
    fixed_ehps = {}
    SKILLS.each do |skill|
      ehp = stats["#{skill}_ehp"]
      fixed_ehps["#{skill}_ehp"] = ehp
      TIMES.each do |time|
        ehp_gain = ehp_diffs["#{skill}_ehp_#{time}"]
        fixed_ehps["#{skill}_ehp_#{time}_start"] = ehp - ehp_gain
      end
    end

    update(fixed_ehps)
  end

  def out_of_date(time, last_updated)
    return true unless last_updated

    case time
    when "day"
      out_of_date = last_updated < Time.now.gmtime.beginning_of_day
    when "week"
      out_of_date = last_updated < Time.now.gmtime.beginning_of_week
    when "month"
      out_of_date = last_updated < Time.now.gmtime.beginning_of_month
    when "year"
      out_of_date = last_updated < Time.now.gmtime.beginning_of_year
    end

    return out_of_date
  end

  def calculate_virtual_stats(stats, last_updated=nil)
    bonus_xp = calc_bonus_xps(stats)
    stats = calc_ehp(stats)
    stats = adjust_bonus_xp(stats, bonus_xp)

    stats = calc_combat(stats)

    stats["ttm_lvl"] = time_to_max(stats, "lvl")
    stats["ttm_xp"] = time_to_max(stats, "xp")

    if stats["overall_ehp"] > 250 or Player.supporters.include?(player_name)
      TIMES.each do |time|
        xp = self.read_attribute("overall_xp_#{time}_start")

        if xp.nil? or xp == 0 or self.out_of_date(time, last_updated)
          stats = update_player_start_stats(time, stats)
        end
      end

      stats = check_record_gains(stats)
    end

    stats
  end

  def check_record_gains(stats_hash)
    SKILLS.each do |skill|
      xp = stats_hash["#{skill}_xp"] || self.read_attribute("#{skill}_xp")
      ehp = stats_hash["#{skill}_ehp"] || self.read_attribute("#{skill}_ehp")
      TIMES.each do |time|
        start_xp = self.read_attribute("#{skill}_xp_#{time}_start")
        start_ehp = self.read_attribute("#{skill}_ehp_#{time}_start")
        max_xp = self.read_attribute("#{skill}_xp_#{time}_max")
        max_ehp = self.read_attribute("#{skill}_ehp_#{time}_max")
        if start_xp.nil? or start_ehp.nil?
          next
        end
        if max_xp.nil? or xp - start_xp > max_xp
          stats_hash["#{skill}_xp_#{time}_max"] = xp - start_xp
        end
        if max_ehp.nil? or ehp - start_ehp > max_ehp
          stats_hash["#{skill}_ehp_#{time}_max"] = ehp - start_ehp
        end
      end
    end

    return stats_hash
  end

  def update_player_start_stats(time, stats_hash)
    SKILLS.each do |skill|
      xp = stats_hash["#{skill}_xp"] || self.read_attribute("#{skill}_xp")
      ehp = stats_hash["#{skill}_ehp"] || self.read_attribute("#{skill}_ehp")
      stats_hash["#{skill}_xp_#{time}_start"] = xp
      stats_hash["#{skill}_ehp_#{time}_start"] = ehp
    end

    return stats_hash
  end

  def calc_skill_ehp(xp, tiers, xphrs)
    ehp = 0
    tiers.each.with_index do |tier, idx|
      tier = tier.to_f
      xphr = xphrs[idx].to_f
      if xphr != 0 and tier < xp
        if (idx+1) < tiers.length and xp >=  tiers[idx+1]
          ehp += (tiers[idx+1].to_f - tier)/xphr
        else
          ehp += (xp.to_f - tier)/xphr
        end
      end
    end
    return ehp
  end

  def calc_max_lvl_ehp(tiers, xphrs)
    return calc_skill_ehp(13034431, tiers, xphrs)
  end

  def calc_max_xp_ehp(tiers, xphrs)
    return calc_skill_ehp(200000000, tiers, xphrs)
  end

  def time_to_max(stats_hash, lvl_or_xp)
    ehp = get_ehp_type
    ttm = 0
    F2POSRSRanks::Application.config.skills.each do |skill|
      if skill != "p2p" and skill != "overall" and skill != "lms" and skill != "p2p_minigame" and skill != "clues_all" and skill != "clues_beginner" and skill != "obor_kc" and skill != "bryophyta_kc"
        skill_xp = stats_hash["#{skill}_xp"]
        if lvl_or_xp == "lvl" and skill_xp >= 13034431
          next
        elsif lvl_or_xp == "xp" and skill_xp == 200000000
          next
        end

        skill_ehp = stats_hash["#{skill}_ehp"]
        adjusted_skill_ehp = calc_skill_ehp(skill_xp, ehp["#{skill}_tiers"], ehp["#{skill}_xphrs"])
        if lvl_or_xp == "lvl"
          max_ehp = calc_max_lvl_ehp(ehp["#{skill}_tiers"], ehp["#{skill}_xphrs"])
        else
          max_ehp = calc_max_xp_ehp(ehp["#{skill}_tiers"], ehp["#{skill}_xphrs"])
        end

        max_ehp = (max_ehp*100).floor/100.0

        if max_ehp > adjusted_skill_ehp
          ttm += max_ehp - adjusted_skill_ehp
        end
      end
    end
    return ttm
  end

  def get_bonus_xp
    case player_acc_type
    when "Reg"
      bonus_xp = F2POSRSRanks::Application.config.bonus_xp_reg
    when "HCIM", "IM"
      bonus_xp = F2POSRSRanks::Application.config.bonus_xp_iron
    when "UIM"
      bonus_xp = F2POSRSRanks::Application.config.bonus_xp_uim
    end
    return bonus_xp
  end

  # Returns hash in the following format.
  # "bonus_for": {bonus_from: expected_xp_in_bonus_for, bonus_from: xp, ...}
  # bonuses: {
  #   "prayer": {"attack": 123, "defence": 12, "strength": 12, ...},
  #   "smithing": {"crafting": 123456},
  #   ...
  # }
  def calc_bonus_xps(stats_hash)
    bonus_xps = get_bonus_xp
    bonuses = {}
    bonus_xps.each do |ratio, bonus_for, bonus_from, start_xp, end_xp|
      skill_from = stats_hash["#{bonus_from}_xp"]
      if skill_from <= start_xp.to_i
        next
      end

      bonus_xp = [([skill_from, end_xp].min - start_xp.to_i)*ratio.to_f, 200000000].min

      if bonuses[bonus_for] and bonuses[bonus_for][bonus_from]
        bonuses[bonus_for][bonus_from] += bonus_xp
      elsif bonuses[bonus_for]
        bonuses[bonus_for][bonus_from] = bonus_xp
      else
        bonuses[bonus_for] = {"#{bonus_from}" => bonus_xp}
      end
    end
    return bonuses
  end

  def calc_ehp(stats_hash)
    ehp = get_ehp_type
    total_ehp = 0.0
    total_lvl = 8
    total_xp = 0
    stats_list = F2POSRSRanks::Application.config.f2p_skills

    stats_list.each.with_index do |skill, skill_idx|
      skill_lvl = stats_hash["#{skill}_lvl"]
      skill_xp = stats_hash["#{skill}_xp"]

      skill_tiers = ehp["#{skill}_tiers"]
      skill_xphrs = ehp["#{skill}_xphrs"]
      skill_ehp = calc_tiered_ehp(skill_tiers, skill_xphrs, skill_xp)

      stats_hash["#{skill}_ehp"] = skill_ehp.round(2)
      total_ehp += skill_ehp.round(2)
      total_xp += skill_xp
      total_lvl += skill_lvl
    end

    stats_hash["overall_ehp"] = total_ehp.round(2)

    if stats_hash["overall_lvl"] < 34
      stats_hash["overall_lvl"] = total_lvl
      stats_hash["overall_xp"] = total_xp
    end

    return stats_hash
  end

  def adjust_bonus_xp(stats_hash, bonus_xp)
    ehp = get_ehp_type
    bonus_xp_list = get_bonus_xp
    bonus_xp.keys.each do |bonus_for|
      if bonus_for == "magic"
        next
      end

      skill_xp = stats_hash["#{bonus_for}_xp"]
      skill_ehp = stats_hash["#{bonus_for}_ehp"]
      skill_tiers = ehp["#{bonus_for}_tiers"]
      skill_xphrs = ehp["#{bonus_for}_xphrs"]
      actual_xp = skill_xp

      # get expected total bonus xp discrepancy
      bonus_xp[bonus_for].keys.each do |bonus_from|
        expected_xp = bonus_xp[bonus_for][bonus_from]
        actual_xp -= expected_xp
      end

      # calc ehp discrepancy
      if actual_xp < 0
        xp_discrepancy = -actual_xp
        if skill_xphrs == [0]
          if bonus_for == "firemaking"
            skill_xphrs = [144600]
            skill_ehp = skill_xp/144600
          elsif bonus_for == "cooking"
            skill_xphrs = [135000]
            skill_ehp = skill_xp/135000
          end
        end
        ehp_discrepancy = calc_skill_ehp(skill_xp + xp_discrepancy, skill_tiers, skill_xphrs) - skill_ehp
      else
        xp_discrepancy = 0
        ehp_discrepancy = 0
      end

      # subtract ehp discrepancy from the bonus_for skill if multiskill bonuses
      if bonus_xp[bonus_for].size > 1
        bonus_for_ehp = stats_hash["#{bonus_for}_ehp"]
        if bonus_for_ehp < ehp_discrepancy
          # puts "1 Subtracting #{ehp_discrepancy} ehp discrepancy and #{bonus_for_ehp} #{bonus_for} from #{stats_hash["overall_ehp"]} overall_ehp."
          stats_hash["overall_ehp"] = (stats_hash["overall_ehp"] - ehp_discrepancy).round(2)
          stats_hash["#{bonus_for}_ehp"] = 0
        else
          # puts "2 Subtracting #{ehp_discrepancy} from #{bonus_for} ehp and #{ehp_discrepancy} from #{stats_hash["overall_ehp"]} overall_ehp."
          stats_hash["#{bonus_for}_ehp"] = (stats_hash["#{bonus_for}_ehp"] - ehp_discrepancy).round(2)
          stats_hash["overall_ehp"] = (stats_hash["overall_ehp"] - ehp_discrepancy).round(2)
        end
      else
        bonus_from = bonus_xp[bonus_for].keys[0]
        bonus_from_ehp = stats_hash["#{bonus_from}_ehp"]
        if bonus_from_ehp < ehp_discrepancy
          # puts "3 Subtracting #{ehp_discrepancy} ehp discrepancy and #{bonus_from_ehp} #{bonus_from} from overall_ehp."
          stats_hash["overall_ehp"] = (stats_hash["overall_ehp"] - ehp_discrepancy - bonus_from_ehp).round(2)
          stats_hash["#{bonus_from}_ehp"] = 0
        else
          # puts "4 Subtracting #{ehp_discrepancy} discrepancy from #{bonus_from} ehp."
          stats_hash["#{bonus_from}_ehp"] = (stats_hash["#{bonus_from}_ehp"] - ehp_discrepancy).round(2)
          stats_hash["overall_ehp"] = (stats_hash["overall_ehp"] - ehp_discrepancy).round(2)
        end
      end
    end
    return stats_hash
  end

  def calc_tiered_ehp(skill_tiers, skill_xphrs, skill_xp)
    skill_ehp = 0.0
    skill_tiers.each.with_index do |skill_tier, tier_idx|
      skill_tier = skill_tier.to_f
      skill_xphr = skill_xphrs[tier_idx].to_f
      if skill_xphr != 0 and skill_tier < skill_xp
        if (tier_idx + 1) < skill_tiers.length and skill_xp >=  skill_tiers[tier_idx + 1]
          skill_ehp += (skill_tiers[tier_idx+1].to_f - skill_tier)/skill_xphr
        else
          skill_ehp += (skill_xp - skill_tier)/skill_xphr
        end
      end
    end
    return skill_ehp
  end

  def repair_tracking(time)
    xps = CML.fetch_exp(player_name, time)
    xp_start = {}

    SKILLS.each do |skill|
      xp_start = xp_start.merge({"#{skill}_xp_#{time}_start" => xps["#{skill}_xp"].to_i})
    end

    ehp = get_ehp_type
    ehp_start = {}
    (SKILLS - ["overall"]).each do |skill|
      skill_ehp = calc_skill_ehp(xps["#{skill}_xp"].to_i, ehp["#{skill}_tiers"], ehp["#{skill}_xphrs"])
      ehp_start = ehp_start.merge({"#{skill}_ehp_#{time}_start" => skill_ehp})
    end
    ehp_start["overall_ehp_#{time}_start"] = ehp_start.values.sum

    update(xp_start.merge(ehp_start))
    return xp_start, ehp_start
  end

  def repair_records
    recs = CML.fetch_records(player_name)
    return unless recs

    ehp = get_ehp_type
    ehp_recs = {}
    (TIMES - ["year"]).each do |time|
      time_recs = {}
      (SKILLS - ["overall"]).each do |skill|
        xp_gain = recs["#{skill}_xp_#{time}_max"].to_i
        curr_xp = self.read_attribute("#{skill}_xp")
        before_xp = curr_xp - xp_gain
        before_ehp = calc_skill_ehp(before_xp, ehp["#{skill}_tiers"], ehp["#{skill}_xphrs"])
        curr_ehp = calc_skill_ehp(curr_xp, ehp["#{skill}_tiers"], ehp["#{skill}_xphrs"])
        ehp_gain = (curr_ehp - before_ehp).round(2)
        time_recs = time_recs.merge({"#{skill}_ehp_#{time}_max" => ehp_gain})
      end
      ehp_recs = ehp_recs.merge(time_recs)
      ehp_recs["overall_ehp_#{time}_max"] = time_recs.values.max
    end

    recs_hash = recs.merge(ehp_recs)
    update(recs_hash)
    return recs_hash
  end

  def recalculate_ehp
    # actually used to recalculate gains and starting ehp, not actual ehp
    skill_hash = {}
    ehp = get_ehp_type
    TIMES.each do |time|
      start_stats_hash = {}
      SKILLS.each do |skill|
        start_xp = self.read_attribute("#{skill}_xp_#{time}_start")
        start_stats_hash["#{skill}_xp"] = start_xp
        start_stats_hash["#{skill}_lvl"] = 1
      end
      bonus_xp = calc_bonus_xps(start_stats_hash)
      start_stats_hash = calc_ehp(start_stats_hash)
      start_stats_hash = adjust_bonus_xp(start_stats_hash, bonus_xp)

      SKILLS.each do |skill|
        skill_hash["#{skill}_ehp_#{time}_start"] = start_stats_hash["#{skill}_ehp"]
      end
    end
    update(skill_hash)
  end

  def recalculate_current_ehp
    # recalculate ehp values using given stats
    # useful to run after pushing ehp changes
    stats_hash = {}
    SKILLS.each do |skill|
      stats_hash["#{skill}_xp"] = self.read_attribute("#{skill}_xp")
      stats_hash["#{skill}_lvl"] = self.read_attribute("#{skill}_lvl")
      stats_hash["#{skill}_rank"] = self.read_attribute("#{skill}_rank")
    end

    update_player(stats: stats_hash)
  end

  def check_p2p_stats(stats)
    actual_f2p_lvls = 0
    (SKILLS - ["overall"]).each do |skill|
      actual_f2p_lvls += stats["#{skill}_lvl"]
    end

    if stats["overall_lvl"] > 1493 or (stats["overall_lvl"] - 8) > actual_f2p_lvls
      update(:potential_p2p => 1)
    end
  end

  def self.initial_p2p_check(stats)
    return true if stats[:potential_p2p] > 0

    actual_f2p_lvls = 0
    (SKILLS - ["overall"]).each do |skill|
      actual_f2p_lvls += (stats["#{skill}_lvl"] or 0)
    end

    return true if (stats["overall_lvl"] - 8) > actual_f2p_lvls
    return false
  end

  def self.create_new(name)
    name = self.sanitize_name(name)
    is_found = self.find_player(name)

    if is_found
      return 'exists'
    elsif F2POSRSRanks::Application.config.downcase_fakes.include?(name.downcase)
      return 'p2p'
    elsif F2POSRSRanks::Application.config.downcase_banned.include?(name.downcase)
      return 'banned'
    end
    puts "not found"

    begin
      stats, account_type = Hiscores.fetch_stats(name)
    rescue SocketError, Net::ReadTimeout
      Rails.logger.warn "#{name}'s hiscores retrieval failed"
      # Stats could not be fetched due to inresponsiveness (3 attempts).
      return 'failed'
    end

    return unless stats  # Player does not exist if return value is nil

    return 'p2p' if initial_p2p_check(stats)

    name = Hiscores.get_registered_player_name(account_type, name)
    return unless name  # Player does not exist if return value is false

    player = Player.create!(player_name: name, player_acc_type: account_type)
    stats[:created_at] = Time.now
    player.update_player(stats: stats)
    player
  end

  # Find the players rank in the database by same arbitrary set of criteria
  # See f2p_skill_rank, f2p_clues_rank, etc. for example usage
  # rank_criteria: A list of [criteria, order] pairs that describe how rank should
  #               be determined. Lower index pairs are used first. Other pairs
  #               are only used in the case of a tie.
  # filter: SQL clause used to restrict which accounts are included in the ranking
  #         curently used to exclude low ehp accounts in gains and record ranks.
  def f2p_rank(rank_criteria, filter=nil)
    # Construct where clause used to rank players according to provided columns
    where_clause = (1..rank_criteria.length).map do |i|
      columns = rank_criteria.take(i)
      primary, ord = columns.last
      secondary = columns.take(columns.length - 1)

      secondary_clauses = secondary.map do |col,_|
        "(#{col} = ?)"
      end.join(" AND ")
      secondary_clauses += " AND" unless secondary_clauses.empty?

      primary_clause = "(#{primary} #{if ord == :DESC then ">" else "<" end} ?)"

      "(#{secondary_clauses} #{primary_clause})"
    end.join(" OR ")
    where_clause = "(potential_p2p <= 0) AND (#{where_clause}) #{"AND (#{filter})" if filter}"

    # Construct parameter list to fill holes in constructed where clause
    where_parameters = (1..rank_criteria.length).map do |i|
      rank_criteria.take(i).map do |col,_|
        # Using eval is definitely a bit of a hack but, I need it to make this
        # method generalize to gains rank
        eval(col)
      end
    end.flatten

    # Rank is the number of records that satisfy the where clause
    1 + Player.where(where_clause, *where_parameters).count
  end

  # Specializes f2p_rank for finding rank in a specific skill.
  def f2p_skill_rank(skill)
    f2p_rank [["#{skill}_ehp", :DESC],
              ["#{skill}_lvl", :DESC],
              ["#{skill}_xp", :DESC],
              ["#{skill}_rank", :ASC],
              ["id", :ASC]]
  end

  # Specializes f2p_rank for finding rank in a clues scroll category.
  def f2p_clues_rank(clue_type)
    f2p_rank [["clues_#{clue_type}", :DESC],
              ["id", :ASC]]
  end

  # Specializes f2p_rank for finding rank in current gains
  def f2p_gains_rank(skill, time)
    f2p_rank [["(#{skill}_ehp - #{skill}_ehp_#{time}_start)", :DESC],
              ["(#{skill}_xp - #{skill}_xp_#{time}_start)", :DESC],
              ["#{skill}_ehp", :DESC],
              ["#{skill}_xp", :DESC],
              ["id", :ASC]],
              "overall_ehp_day_start > 0 AND (overall_ehp > 250 OR player_name IN #{Player.sql_supporters})"

  end

  # Specializes f2p_rank for finding rank in record gains
  def f2p_record_rank(skill, time)
    f2p_rank [["#{skill}_ehp_#{time}_max", :DESC],
              ["#{skill}_xp_#{time}_max", :DESC],
              ["#{skill}_ehp", :DESC],
              ["#{skill}_xp", :DESC],
              ["id", :ASC]],
              "overall_ehp_day_max > 0 AND (overall_ehp > 250 OR player_name IN #{Player.sql_supporters})"
  end

  def count_99
    count = 0

    (SKILLS - ["overall"]).each do |skill|
      count += 1 if self.read_attribute("#{skill}_lvl") >= 99
    end

    return count
  end

  def count_200m
    count = 0

    (SKILLS - ["overall"]).each do |skill|
      count += 1 if self.read_attribute("#{skill}_xp") >= 200000000
    end

    return count
  end

  def lowest_lvl
    skill_lvls = (SKILLS - ["overall"]).each.map { |skill| self.read_attribute("#{skill}_lvl").to_i }
    return skill_lvls.min
  end

  private

  def register_hcim_death
    self.hcim_has_died = true
    self.hcim_has_died_registered_at = DateTime.now
  end
end
