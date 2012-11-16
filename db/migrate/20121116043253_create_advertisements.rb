class CreateAdvertisements < ActiveRecord::Migration
  def change
    create_table :advertisements do |t|
      t.integer :user_id
      t.integer :board_id
      t.integer :width
      t.integer :height
      t.binary :image
      t.integer :x_location
      t.integer :y_location

      t.timestamps
    end
  end
end
