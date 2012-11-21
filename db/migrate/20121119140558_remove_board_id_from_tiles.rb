class RemoveBoardIdFromTiles < ActiveRecord::Migration
  def up
		remove_column :tiles, :board_id
  end

  def down
		add_column :tiles, :board_id, :integer
  end
end
