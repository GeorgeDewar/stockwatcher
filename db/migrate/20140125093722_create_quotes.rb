class CreateQuotes < ActiveRecord::Migration
  def change
    create_table :quotes do |t|
      t.references :stock, index: true
      t.number :price

      t.timestamps
    end
  end
end
