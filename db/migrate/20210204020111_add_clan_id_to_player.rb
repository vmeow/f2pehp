class AddClanIdToPlayer < ActiveRecord::Migration[5.2]
  def change
    add_column :players, :clan_id, :integer
  end
end
