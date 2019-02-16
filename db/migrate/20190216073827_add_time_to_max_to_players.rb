class AddTimeToMaxToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :ttm_lvl, :float
    add_column :players, :ttm_xp, :float
  end
end
