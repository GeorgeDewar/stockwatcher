class CreateStocks < ActiveRecord::Migration
  def change
    create_table :stocks do |t|
      t.string :code, limit: 3, :null => false
      t.string :name, limit: 50, :null => false

      t.timestamps
    end
    add_index :stocks, :code, unique: true
  end
end
