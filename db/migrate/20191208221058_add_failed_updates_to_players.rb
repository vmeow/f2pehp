class AddFailedUpdatesToPlayers < ActiveRecord::Migration[5.2]
  def change
    add_column :players, :failed_updates, :int, default: 0
  end
end
