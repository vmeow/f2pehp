class AddSlugsToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :slug, :string
    add_index :players, :slug, unique: true
  end
end
