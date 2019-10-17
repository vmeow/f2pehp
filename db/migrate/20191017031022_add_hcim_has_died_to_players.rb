class AddHcimHasDiedToPlayers < ActiveRecord::Migration[5.2]
  def change
    add_column :players, :hcim_has_died, :boolean, default: 0
    add_column :players, :hcim_has_died_registrered_at, :datetime
  end
end
