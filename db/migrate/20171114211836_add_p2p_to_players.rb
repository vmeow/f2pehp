class AddP2pToPlayers < ActiveRecord::Migration[4.2]
  def change
    add_column :players, :potential_p2p, :string
  end
end
