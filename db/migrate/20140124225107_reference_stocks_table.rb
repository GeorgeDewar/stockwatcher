class ReferenceStocksTable < ActiveRecord::Migration
  def change
  	change_table(:watches) do |t|
  	  t.references :stock, index: true
  	end
  	remove_column :watches, :code
  end
end
