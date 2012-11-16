class CreateTiles < ActiveRecord::Migration
  def change
    create_table :tiles do |t|
      t.integer :board_id
      t.integer :advertisement_id
      t.integer :x_location
      t.integer :y_location
      t.decimal :cost

      t.timestamps
    end
  end
end
