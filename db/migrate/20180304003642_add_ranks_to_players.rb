class AddRanksToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :overall_rank, :integer
    add_column :players, :attack_rank, :integer
    add_column :players, :defence_rank, :integer
    add_column :players, :strength_rank, :integer
    add_column :players, :hitpoints_rank, :integer
    add_column :players, :ranged_rank, :integer
    add_column :players, :prayer_rank, :integer
    add_column :players, :magic_rank, :integer
    add_column :players, :cooking_rank, :integer
    add_column :players, :woodcutting_rank, :integer
    add_column :players, :fishing_rank, :integer
    add_column :players, :firemaking_rank, :integer
    add_column :players, :crafting_rank, :integer
    add_column :players, :smithing_rank, :integer
    add_column :players, :mining_rank, :integer
    add_column :players, :runecraft_rank, :integer
  end
end
