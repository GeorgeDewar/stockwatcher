class MarkFieldsNotNull < ActiveRecord::Migration
  def change
  	change_column :watches, :stock_id, :integer, :null => false
  	change_column :watches, :threshold, :number, :null => false
  	change_column :watches, :user_id, :integer, :null => false
  end
end
