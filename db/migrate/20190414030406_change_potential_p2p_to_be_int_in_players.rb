class ChangePotentialP2pToBeIntInPlayers < ActiveRecord::Migration
  def change
    change_column :players, :potential_p2p, :int
  end
end
