class AddCombatToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :combat_lvl, :integer
  end
end
