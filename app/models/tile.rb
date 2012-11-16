class Tile < ActiveRecord::Base
  attr_accessible :advertisement_id, :board_id, :cost, :x_location, :y_location

	belongs_to :advertisement
	belongs_to :board
end
