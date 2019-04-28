class AddEhpCompToPlayers < ActiveRecord::Migration[4.2]
  def change
    add_column :players, :overall_ehp_start, :float
    add_column :players, :overall_ehp_end, :float
  end
end
