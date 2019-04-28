class AddOverallTrackingToPlayers < ActiveRecord::Migration[4.2]
  def change
    add_column :players, :overall_xp_day_start, :int
    add_column :players, :overall_xp_day_max, :int
    add_column :players, :overall_ehp_day_start, :float
    add_column :players, :overall_ehp_day_max, :float
    add_column :players, :overall_xp_week_start, :int
    add_column :players, :overall_xp_week_max, :int
    add_column :players, :overall_ehp_week_start, :float
    add_column :players, :overall_ehp_week_max, :float
    add_column :players, :overall_xp_month_start, :int
    add_column :players, :overall_xp_month_max, :int
    add_column :players, :overall_ehp_month_start, :float
    add_column :players, :overall_ehp_month_max, :float
    add_column :players, :overall_xp_year_start, :int
    add_column :players, :overall_xp_year_max, :int
    add_column :players, :overall_ehp_year_start, :float
    add_column :players, :overall_ehp_year_max, :float
  end
end
