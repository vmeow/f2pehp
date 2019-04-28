class AddCombatLevelToPlayers < ActiveRecord::Migration[4.2]
  def change
    add_column :players, :combat_lvl, :integer
  end
end
