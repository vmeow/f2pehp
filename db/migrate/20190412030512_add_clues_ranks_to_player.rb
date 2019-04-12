class AddCluesRanksToPlayer < ActiveRecord::Migration
  def change
    add_column :players, :clues_all_rank, :int
    add_column :players, :clues_beginner_rank, :int
  end
end
