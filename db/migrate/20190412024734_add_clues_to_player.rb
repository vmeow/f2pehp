class AddCluesToPlayer < ActiveRecord::Migration[4.2]
  def change
    add_column :players, :clues_all, :int
    add_column :players, :clues_beginner, :int
  end
end
