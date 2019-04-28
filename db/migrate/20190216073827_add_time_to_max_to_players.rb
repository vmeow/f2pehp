class AddTimeToMaxToPlayers < ActiveRecord::Migration[4.2]
  def change
    add_column :players, :ttm_lvl, :float
    add_column :players, :ttm_xp, :float
  end
end
