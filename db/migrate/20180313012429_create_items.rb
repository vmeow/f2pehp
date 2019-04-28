class CreateItems < ActiveRecord::Migration[4.2]
  def change
    create_table :items do |t|
      t.string :name
      t.integer :itemid
      t.string :icon
      t.integer :alch
      t.integer :current

      t.timestamps null: false
    end
  end
end
