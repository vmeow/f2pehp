class AddLinkNamesToClans < ActiveRecord::Migration[5.2]
  def change
    add_column :clans, :link1_name, :string
    add_column :clans, :link2_name, :string
  end
end
