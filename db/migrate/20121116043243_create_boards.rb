class CreateBoards < ActiveRecord::Migration
  def change
    create_table :boards do |t|
      t.integer :user_id
      t.string :name
      t.integer :width
      t.integer :height
      t.string :timezone

      t.timestamps
    end
  end
end
