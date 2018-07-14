class ChangeCombatToBeFloatInPlayers < ActiveRecord::Migration
  def change
    change_column :players, :combat_lvl, :float
  end
end
