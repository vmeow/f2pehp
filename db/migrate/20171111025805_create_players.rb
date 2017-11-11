class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :player_name
      t.string :player_acc_type
      t.integer :overall_xp
      t.integer :overall_lvl
      t.float :overall_ehp
      t.integer :attack_xp
      t.integer :attack_lvl
      t.float :attack_ehp
      t.integer :defence_xp
      t.integer :defence_lvl
      t.float :defence_ehp
      t.integer :strength_xp
      t.integer :strength_lvl
      t.float :strength_ehp
      t.integer :hitpoints_xp
      t.integer :hitpoints_lvl
      t.float :hitpoints_ehp
      t.integer :ranged_xp
      t.integer :ranged_lvl
      t.float :ranged_ehp
      t.integer :prayer_xp
      t.integer :prayer_lvl
      t.float :prayer_ehp
      t.integer :magic_xp
      t.integer :magic_lvl
      t.float :magic_ehp
      t.integer :cooking_xp
      t.integer :cooking_lvl
      t.float :cooking_ehp
      t.integer :woodcutting_xp
      t.integer :woodcutting_lvl
      t.float :woodcutting_ehp
      t.integer :fishing_xp
      t.integer :fishing_lvl
      t.float :fishing_ehp
      t.integer :firemaking_xp
      t.integer :firemaking_lvl
      t.float :firemaking_ehp
      t.integer :crafting_xp
      t.integer :crafting_lvl
      t.float :crafting_ehp
      t.integer :smithing_xp
      t.integer :smithing_lvl
      t.float :smithing_ehp
      t.integer :mining_xp
      t.integer :mining_lvl
      t.float :mining_ehp
      t.integer :runecraft_xp
      t.integer :runecraft_lvl
      t.float :runecraft_ehp
    end
  end
end
