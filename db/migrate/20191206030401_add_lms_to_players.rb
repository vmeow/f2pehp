class AddLmsToPlayers < ActiveRecord::Migration[5.2]
  def change
    add_column :players, :lms_score, :int
    add_column :players, :lms_rank, :int
  end
end
