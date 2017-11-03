class AddColumnToItem < ActiveRecord::Migration
  def change
    add_column :items, :name_of_clinic, :string
    add_column :items, :grant_year, :string
  end
end
