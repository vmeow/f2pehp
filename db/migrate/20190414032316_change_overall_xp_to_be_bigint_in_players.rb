class ChangeOverallXpToBeBigintInPlayers < ActiveRecord::Migration
  def change
    change_column :players, :overall_xp, :bigint
  end
end
