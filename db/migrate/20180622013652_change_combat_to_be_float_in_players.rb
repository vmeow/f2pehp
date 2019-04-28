class ChangeCombatToBeFloatInPlayers < ActiveRecord::Migration[4.2]
  def change
    change_column :players, :combat_lvl, :float
  end
end
