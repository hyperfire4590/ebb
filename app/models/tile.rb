class Tile < ActiveRecord::Base
  attr_accessible :x_location, :y_location
	attr_protected :cost, :board_id, :advertisement_id
	
	belongs_to :advertisement
	has_one :board, through: :advertisement

	validates :x_location, presence: true,
		:numericality => { :greater_than_or_equal_to => 0 }	
	validates :y_location, presence: true,
		:numericality => { :greater_than_or_equal_to => 0 }
	validates :cost, presence: true,
		:numericality => { :greater_than_or_equal_to => 0 }

	validate :check_tile_bounds

	private
		
		def check_tile_bounds
			unless x_location.nil?
				if x_location >= advertisement.width + advertisement.x_location
					errors.add(:x_location,
						"x_location is greater than or equal to ad width + x_location.")
				end
				if x_location >= board.width
					errors.add(:x_location,
						"x_location is greater than or equal to board width.")
				end
				if x_location < advertisement.x_location
					errors.add(:x_location,
						"x_location is less than add x_location.")
				end
			end
			unless y_location.nil?
				if y_location >= advertisement.height + advertisement.y_location
					errors.add(:y_location,
						"y_location is greater than or equal to ad height + y_location.")
				end
				if y_location >= board.height
					errors.add(:y_location,
						"y_location is greater than or equal to board height.")
				end
				if y_location < advertisement.y_location
					errors.add(:y_location,
						"y_location is less than ad y_location.")
				end
			end
		end

end
