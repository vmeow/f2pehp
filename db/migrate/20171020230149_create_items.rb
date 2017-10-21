class CreateItems < ActiveRecord::Migration
  # def change
  #   create_table :items do |t|
  #
  #     t.timestamps null: false
  #   end
  # end


  def up
    create_table :items do |t|
      t.string :client_ssn
      t.string :client_name
      t.string :case_type
      t.string :status
      t.datetime :date_opened
      t.datetime :date_closed
      t.timestamps null: false
    end
  end
  
  def down
    drop_table :items
  end
end
