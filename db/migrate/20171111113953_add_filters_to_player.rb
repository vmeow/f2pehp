class AddFiltersToPlayer < ActiveRecord::Migration
  def change
    add_column :players, :filter_acc, :string
    add_column :players, :sort_skill, :string
  end
end
