class AddCreatedAtAndUpdatedAtToPlayers < ActiveRecord::Migration[5.2]
  def change
    add_column :players, :created_at, :timestamp
    add_column :players, :updated_at, :timestamp
  end
end
