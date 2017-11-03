class AddGlitchedTaxCourtColumnsToItem < ActiveRecord::Migration
  def change
    add_column :items, :tax_court_appearances, :string
    add_column :items, :tax_court_no_appearance, :string
  end
end
