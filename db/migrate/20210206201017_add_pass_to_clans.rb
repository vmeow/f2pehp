class AddPassToClans < ActiveRecord::Migration[5.2]
  def change
    add_column :clans, :pass, :string
  end
end
