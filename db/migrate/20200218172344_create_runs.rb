class CreateRuns < ActiveRecord::Migration[5.2]
  def change
    create_table :runs do |t|
      t.timestamp :hour
      t.integer :failed_updates
    end
  end
end
