class RemoveClanIdFromPlayers < ActiveRecord::Migration[5.2]
  def change
    remove_column :players, :clan_id, :integer
  end
end
