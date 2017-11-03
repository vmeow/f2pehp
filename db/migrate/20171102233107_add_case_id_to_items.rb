class AddCaseIdToItems < ActiveRecord::Migration
  def change
    add_column :items, :case_id, :string
  end
end
