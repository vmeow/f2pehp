class RemoveSeveralColumnsFromPlayers < ActiveRecord::Migration[5.2]
  def change
    remove_column :players, :filter_acc, :string
    remove_column :players, :sort_skill, :string
    remove_column :players, :overall_ehp_start, :float
    remove_column :players, :overall_ehp_end, :float
    remove_column :players, :mining_ehp_start, :float
    remove_column :players, :mining_ehp_end, :float
    remove_column :players, :fishing_ehp_start, :float
    remove_column :players, :fishing_ehp_end, :float
    remove_column :players, :woodcutting_ehp_start, :float
    remove_column :players, :woodcutting_ehp_end, :float
    remove_column :players, :firemaking_ehp_start, :float
    remove_column :players, :firemaking_ehp_end, :float
    remove_column :players, :cooking_ehp_start, :float
    remove_column :players, :cooking_ehp_end, :float
  end
end
