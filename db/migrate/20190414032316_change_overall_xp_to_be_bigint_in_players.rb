class ChangeOverallXpToBeBigintInPlayers < ActiveRecord::Migration[4.2]
  def change
    change_column :players, :overall_xp, :bigint
  end
end
