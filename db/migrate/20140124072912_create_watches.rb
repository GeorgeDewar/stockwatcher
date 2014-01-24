class CreateWatches < ActiveRecord::Migration
  def change
    create_table :watches do |t|
      t.string :code
      t.decimal :threshold
      t.references :user, index: true

      t.timestamps
    end
  end
end
