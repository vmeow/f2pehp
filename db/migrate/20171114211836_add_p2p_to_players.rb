class AddP2pToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :potential_p2p, :string
  end
end
