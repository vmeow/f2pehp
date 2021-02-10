class CreatePlayerClanLinks < ActiveRecord::Migration[5.2]
  def change
    create_table :player_clan_links, id: false do |t|
      t.integer :player_id
      t.integer :clan_id
      t.timestamps
    end
  end
end
