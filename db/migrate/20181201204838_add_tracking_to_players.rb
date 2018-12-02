class AddTrackingToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :attack_xp_day_start, :int
    add_column :players, :attack_xp_day_max, :int
    add_column :players, :attack_ehp_day_start, :float
    add_column :players, :attack_ehp_day_max, :float
    add_column :players, :attack_xp_week_start, :int
    add_column :players, :attack_xp_week_max, :int
    add_column :players, :attack_ehp_week_start, :float
    add_column :players, :attack_ehp_week_max, :float
    add_column :players, :attack_xp_month_start, :int
    add_column :players, :attack_xp_month_max, :int
    add_column :players, :attack_ehp_month_start, :float
    add_column :players, :attack_ehp_month_max, :float
    add_column :players, :attack_xp_year_start, :int
    add_column :players, :attack_xp_year_max, :int
    add_column :players, :attack_ehp_year_start, :float
    add_column :players, :attack_ehp_year_max, :float
    add_column :players, :strength_xp_day_start, :int
    add_column :players, :strength_xp_day_max, :int
    add_column :players, :strength_ehp_day_start, :float
    add_column :players, :strength_ehp_day_max, :float
    add_column :players, :strength_xp_week_start, :int
    add_column :players, :strength_xp_week_max, :int
    add_column :players, :strength_ehp_week_start, :float
    add_column :players, :strength_ehp_week_max, :float
    add_column :players, :strength_xp_month_start, :int
    add_column :players, :strength_xp_month_max, :int
    add_column :players, :strength_ehp_month_start, :float
    add_column :players, :strength_ehp_month_max, :float
    add_column :players, :strength_xp_year_start, :int
    add_column :players, :strength_xp_year_max, :int
    add_column :players, :strength_ehp_year_start, :float
    add_column :players, :strength_ehp_year_max, :float
    add_column :players, :defence_xp_day_start, :int
    add_column :players, :defence_xp_day_max, :int
    add_column :players, :defence_ehp_day_start, :float
    add_column :players, :defence_ehp_day_max, :float
    add_column :players, :defence_xp_week_start, :int
    add_column :players, :defence_xp_week_max, :int
    add_column :players, :defence_ehp_week_start, :float
    add_column :players, :defence_ehp_week_max, :float
    add_column :players, :defence_xp_month_start, :int
    add_column :players, :defence_xp_month_max, :int
    add_column :players, :defence_ehp_month_start, :float
    add_column :players, :defence_ehp_month_max, :float
    add_column :players, :defence_xp_year_start, :int
    add_column :players, :defence_xp_year_max, :int
    add_column :players, :defence_ehp_year_start, :float
    add_column :players, :defence_ehp_year_max, :float
    add_column :players, :hitpoints_xp_day_start, :int
    add_column :players, :hitpoints_xp_day_max, :int
    add_column :players, :hitpoints_ehp_day_start, :float
    add_column :players, :hitpoints_ehp_day_max, :float
    add_column :players, :hitpoints_xp_week_start, :int
    add_column :players, :hitpoints_xp_week_max, :int
    add_column :players, :hitpoints_ehp_week_start, :float
    add_column :players, :hitpoints_ehp_week_max, :float
    add_column :players, :hitpoints_xp_month_start, :int
    add_column :players, :hitpoints_xp_month_max, :int
    add_column :players, :hitpoints_ehp_month_start, :float
    add_column :players, :hitpoints_ehp_month_max, :float
    add_column :players, :hitpoints_xp_year_start, :int
    add_column :players, :hitpoints_xp_year_max, :int
    add_column :players, :hitpoints_ehp_year_start, :float
    add_column :players, :hitpoints_ehp_year_max, :float
    add_column :players, :ranged_xp_day_start, :int
    add_column :players, :ranged_xp_day_max, :int
    add_column :players, :ranged_ehp_day_start, :float
    add_column :players, :ranged_ehp_day_max, :float
    add_column :players, :ranged_xp_week_start, :int
    add_column :players, :ranged_xp_week_max, :int
    add_column :players, :ranged_ehp_week_start, :float
    add_column :players, :ranged_ehp_week_max, :float
    add_column :players, :ranged_xp_month_start, :int
    add_column :players, :ranged_xp_month_max, :int
    add_column :players, :ranged_ehp_month_start, :float
    add_column :players, :ranged_ehp_month_max, :float
    add_column :players, :ranged_xp_year_start, :int
    add_column :players, :ranged_xp_year_max, :int
    add_column :players, :ranged_ehp_year_start, :float
    add_column :players, :ranged_ehp_year_max, :float
    add_column :players, :prayer_xp_day_start, :int
    add_column :players, :prayer_xp_day_max, :int
    add_column :players, :prayer_ehp_day_start, :float
    add_column :players, :prayer_ehp_day_max, :float
    add_column :players, :prayer_xp_week_start, :int
    add_column :players, :prayer_xp_week_max, :int
    add_column :players, :prayer_ehp_week_start, :float
    add_column :players, :prayer_ehp_week_max, :float
    add_column :players, :prayer_xp_month_start, :int
    add_column :players, :prayer_xp_month_max, :int
    add_column :players, :prayer_ehp_month_start, :float
    add_column :players, :prayer_ehp_month_max, :float
    add_column :players, :prayer_xp_year_start, :int
    add_column :players, :prayer_xp_year_max, :int
    add_column :players, :prayer_ehp_year_start, :float
    add_column :players, :prayer_ehp_year_max, :float
    add_column :players, :magic_xp_day_start, :int
    add_column :players, :magic_xp_day_max, :int
    add_column :players, :magic_ehp_day_start, :float
    add_column :players, :magic_ehp_day_max, :float
    add_column :players, :magic_xp_week_start, :int
    add_column :players, :magic_xp_week_max, :int
    add_column :players, :magic_ehp_week_start, :float
    add_column :players, :magic_ehp_week_max, :float
    add_column :players, :magic_xp_month_start, :int
    add_column :players, :magic_xp_month_max, :int
    add_column :players, :magic_ehp_month_start, :float
    add_column :players, :magic_ehp_month_max, :float
    add_column :players, :magic_xp_year_start, :int
    add_column :players, :magic_xp_year_max, :int
    add_column :players, :magic_ehp_year_start, :float
    add_column :players, :magic_ehp_year_max, :float
    add_column :players, :cooking_xp_day_start, :int
    add_column :players, :cooking_xp_day_max, :int
    add_column :players, :cooking_ehp_day_start, :float
    add_column :players, :cooking_ehp_day_max, :float
    add_column :players, :cooking_xp_week_start, :int
    add_column :players, :cooking_xp_week_max, :int
    add_column :players, :cooking_ehp_week_start, :float
    add_column :players, :cooking_ehp_week_max, :float
    add_column :players, :cooking_xp_month_start, :int
    add_column :players, :cooking_xp_month_max, :int
    add_column :players, :cooking_ehp_month_start, :float
    add_column :players, :cooking_ehp_month_max, :float
    add_column :players, :cooking_xp_year_start, :int
    add_column :players, :cooking_xp_year_max, :int
    add_column :players, :cooking_ehp_year_start, :float
    add_column :players, :cooking_ehp_year_max, :float
    add_column :players, :woodcutting_xp_day_start, :int
    add_column :players, :woodcutting_xp_day_max, :int
    add_column :players, :woodcutting_ehp_day_start, :float
    add_column :players, :woodcutting_ehp_day_max, :float
    add_column :players, :woodcutting_xp_week_start, :int
    add_column :players, :woodcutting_xp_week_max, :int
    add_column :players, :woodcutting_ehp_week_start, :float
    add_column :players, :woodcutting_ehp_week_max, :float
    add_column :players, :woodcutting_xp_month_start, :int
    add_column :players, :woodcutting_xp_month_max, :int
    add_column :players, :woodcutting_ehp_month_start, :float
    add_column :players, :woodcutting_ehp_month_max, :float
    add_column :players, :woodcutting_xp_year_start, :int
    add_column :players, :woodcutting_xp_year_max, :int
    add_column :players, :woodcutting_ehp_year_start, :float
    add_column :players, :woodcutting_ehp_year_max, :float
    add_column :players, :fishing_xp_day_start, :int
    add_column :players, :fishing_xp_day_max, :int
    add_column :players, :fishing_ehp_day_start, :float
    add_column :players, :fishing_ehp_day_max, :float
    add_column :players, :fishing_xp_week_start, :int
    add_column :players, :fishing_xp_week_max, :int
    add_column :players, :fishing_ehp_week_start, :float
    add_column :players, :fishing_ehp_week_max, :float
    add_column :players, :fishing_xp_month_start, :int
    add_column :players, :fishing_xp_month_max, :int
    add_column :players, :fishing_ehp_month_start, :float
    add_column :players, :fishing_ehp_month_max, :float
    add_column :players, :fishing_xp_year_start, :int
    add_column :players, :fishing_xp_year_max, :int
    add_column :players, :fishing_ehp_year_start, :float
    add_column :players, :fishing_ehp_year_max, :float
    add_column :players, :firemaking_xp_day_start, :int
    add_column :players, :firemaking_xp_day_max, :int
    add_column :players, :firemaking_ehp_day_start, :float
    add_column :players, :firemaking_ehp_day_max, :float
    add_column :players, :firemaking_xp_week_start, :int
    add_column :players, :firemaking_xp_week_max, :int
    add_column :players, :firemaking_ehp_week_start, :float
    add_column :players, :firemaking_ehp_week_max, :float
    add_column :players, :firemaking_xp_month_start, :int
    add_column :players, :firemaking_xp_month_max, :int
    add_column :players, :firemaking_ehp_month_start, :float
    add_column :players, :firemaking_ehp_month_max, :float
    add_column :players, :firemaking_xp_year_start, :int
    add_column :players, :firemaking_xp_year_max, :int
    add_column :players, :firemaking_ehp_year_start, :float
    add_column :players, :firemaking_ehp_year_max, :float
    add_column :players, :crafting_xp_day_start, :int
    add_column :players, :crafting_xp_day_max, :int
    add_column :players, :crafting_ehp_day_start, :float
    add_column :players, :crafting_ehp_day_max, :float
    add_column :players, :crafting_xp_week_start, :int
    add_column :players, :crafting_xp_week_max, :int
    add_column :players, :crafting_ehp_week_start, :float
    add_column :players, :crafting_ehp_week_max, :float
    add_column :players, :crafting_xp_month_start, :int
    add_column :players, :crafting_xp_month_max, :int
    add_column :players, :crafting_ehp_month_start, :float
    add_column :players, :crafting_ehp_month_max, :float
    add_column :players, :crafting_xp_year_start, :int
    add_column :players, :crafting_xp_year_max, :int
    add_column :players, :crafting_ehp_year_start, :float
    add_column :players, :crafting_ehp_year_max, :float
    add_column :players, :smithing_xp_day_start, :int
    add_column :players, :smithing_xp_day_max, :int
    add_column :players, :smithing_ehp_day_start, :float
    add_column :players, :smithing_ehp_day_max, :float
    add_column :players, :smithing_xp_week_start, :int
    add_column :players, :smithing_xp_week_max, :int
    add_column :players, :smithing_ehp_week_start, :float
    add_column :players, :smithing_ehp_week_max, :float
    add_column :players, :smithing_xp_month_start, :int
    add_column :players, :smithing_xp_month_max, :int
    add_column :players, :smithing_ehp_month_start, :float
    add_column :players, :smithing_ehp_month_max, :float
    add_column :players, :smithing_xp_year_start, :int
    add_column :players, :smithing_xp_year_max, :int
    add_column :players, :smithing_ehp_year_start, :float
    add_column :players, :smithing_ehp_year_max, :float
    add_column :players, :mining_xp_day_start, :int
    add_column :players, :mining_xp_day_max, :int
    add_column :players, :mining_ehp_day_start, :float
    add_column :players, :mining_ehp_day_max, :float
    add_column :players, :mining_xp_week_start, :int
    add_column :players, :mining_xp_week_max, :int
    add_column :players, :mining_ehp_week_start, :float
    add_column :players, :mining_ehp_week_max, :float
    add_column :players, :mining_xp_month_start, :int
    add_column :players, :mining_xp_month_max, :int
    add_column :players, :mining_ehp_month_start, :float
    add_column :players, :mining_ehp_month_max, :float
    add_column :players, :mining_xp_year_start, :int
    add_column :players, :mining_xp_year_max, :int
    add_column :players, :mining_ehp_year_start, :float
    add_column :players, :mining_ehp_year_max, :float
    add_column :players, :runecraft_xp_day_start, :int
    add_column :players, :runecraft_xp_day_max, :int
    add_column :players, :runecraft_ehp_day_start, :float
    add_column :players, :runecraft_ehp_day_max, :float
    add_column :players, :runecraft_xp_week_start, :int
    add_column :players, :runecraft_xp_week_max, :int
    add_column :players, :runecraft_ehp_week_start, :float
    add_column :players, :runecraft_ehp_week_max, :float
    add_column :players, :runecraft_xp_month_start, :int
    add_column :players, :runecraft_xp_month_max, :int
    add_column :players, :runecraft_ehp_month_start, :float
    add_column :players, :runecraft_ehp_month_max, :float
    add_column :players, :runecraft_xp_year_start, :int
    add_column :players, :runecraft_xp_year_max, :int
    add_column :players, :runecraft_ehp_year_start, :float
    add_column :players, :runecraft_ehp_year_max, :float
  end
end