class ChangeOverallXpToBeBigintInPlayers2 < ActiveRecord::Migration[6.1]
  def change
    change_column :players, :overall_xp, :bigint
  end
end
