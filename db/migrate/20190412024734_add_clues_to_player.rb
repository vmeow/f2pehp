class AddCluesToPlayer < ActiveRecord::Migration
  def change
    add_column :players, :clues_all, :int
    add_column :players, :clues_beginner, :int
  end
end
