class AddGatherersTrackingToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :mining_ehp_start, :float
    add_column :players, :mining_ehp_end, :float
    add_column :players, :fishing_ehp_start, :float
    add_column :players, :fishing_ehp_end, :float
    add_column :players, :woodcutting_ehp_start, :float
    add_column :players, :woodcutting_ehp_end, :float
    add_column :players, :firemaking_ehp_start, :float
    add_column :players, :firemaking_ehp_end, :float
    add_column :players, :cooking_ehp_start, :float
    add_column :players, :cooking_ehp_end, :float
  end
end
