class CreateAlerts < ActiveRecord::Migration
  def change
    create_table :alerts do |t|
      t.references :watch, index: true

      t.belongs_to :previous_quote
      t.belongs_to :current_quote

      t.timestamps
    end
  end
end
