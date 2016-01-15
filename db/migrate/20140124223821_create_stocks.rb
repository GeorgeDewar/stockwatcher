class CreateStocks < ActiveRecord::Migration
  def change
    create_table :stocks do |t|
      t.string :code, :null => false
      t.string :name, :null => false

      t.timestamps
    end
    add_index :stocks, :code, unique: true
  end
end
