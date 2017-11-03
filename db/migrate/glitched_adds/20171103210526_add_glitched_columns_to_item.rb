class AddGlitchedColumnsToItem < ActiveRecord::Migration
  def change
    add_column :items, :status_issues_injured_spouse, :string
    add_column :items, :status_issues_innocent_spouse, :string
    add_column :items, :status_issues_employment_related_identity_theft, :string
  end
end
