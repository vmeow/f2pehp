class UpdateOverallDayStartXpToBigInt < ActiveRecord::Migration[6.1]
  def change
    change_column :players, :overall_xp_day_start, :bigint
  end
end
