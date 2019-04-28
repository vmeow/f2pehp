class AddFiltersToPlayer < ActiveRecord::Migration[4.2]
  def change
    add_column :players, :filter_acc, :string
    add_column :players, :sort_skill, :string
  end
end
