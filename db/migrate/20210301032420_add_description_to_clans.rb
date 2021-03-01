class AddDescriptionToClans < ActiveRecord::Migration[5.2]
  def change
    add_column :clans, :description, :string
    add_column :clans, :link1, :string
    add_column :clans, :link2, :string
  end
end
