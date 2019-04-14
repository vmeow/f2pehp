class ChangePotentialP2pToBeIntInPlayers < ActiveRecord::Migration
  def change
    change_column :players, :potential_p2p, 'float USING CAST(potential_p2p AS float)'
  end
end
