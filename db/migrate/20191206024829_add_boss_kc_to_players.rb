class AddBossKcToPlayers < ActiveRecord::Migration[5.2]
  def change
    add_column :players, :obor_kc, :int
    add_column :players, :bryo_kc, :int
    add_column :players, :obor_kc_rank, :int
    add_column :players, :bryo_kc_rank, :int
  end
end
