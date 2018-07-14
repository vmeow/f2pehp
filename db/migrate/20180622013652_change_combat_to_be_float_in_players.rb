class AddCombatLevelToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :combat_level, :integer
  end
end
