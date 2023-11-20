class UpdateXpStartToBigInt < ActiveRecord::Migration[6.1]
  def change
    change_column :players, :overall_xp_week_start, :bigint
    change_column :players, :overall_xp_month_start, :bigint
    change_column :players, :overall_xp_year_start, :bigint
  end
end
