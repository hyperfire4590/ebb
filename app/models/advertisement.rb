class Advertisement < ActiveRecord::Base
  attr_accessible :height, :image, :width, :x_location, :y_location
	attr_protected :board_id, :user_id

	has_many :tiles
	belongs_to :user
	belongs_to :board
	has_many :payment_details, as: :payable

	validates :x_location, presence: true, 
			:numericality => { :greater_than_or_equal_to => 0 }
	validates :y_location, presence: true,
			:numericality => { :greater_than_or_equal_to => 0 }
	validates :width, presence: true, 
			:numericality => { :greater_than_or_equal_to => 1 }
	validates :height, presence: true,
			:numericality => { :greater_than_or_equal_to => 1 }
	validates :image, presence: true

	#validates :height, :less_than => Board.find_by_id(:board_id).height
	validate :check_advertisement_bounds

	private

		def check_advertisement_bounds
			unless x_location.nil?
				if board.width <= x_location
					errors.add(:x_location, 
						"Board width is less than or equal to x_location.")
				end
				if board.width <= x_location + width
					errors.add(:width, 
						"Board width is less than or equal to x_location plus width.")
				end
			end
			
			unless y_location.nil?
				if board.height <= y_location
					errors.add(:y_location,
						"Board height is less than or equal to y_location.")
				end
				if board.height <= y_location + height
					errors.add(:height, 
						"Board height is less than or equal to y_location plus height.")
				end
			end	
	
		end

end
