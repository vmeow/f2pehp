class AddEhpCompToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :overall_ehp_start, :float
    add_column :players, :overall_ehp_end, :float
  end
end
