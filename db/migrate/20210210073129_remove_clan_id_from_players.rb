class RemoveClanIdFromPlayers < ActiveRecord::Migration[5.2]
  def change
    remove_column :players, :clan_id
  end
end
