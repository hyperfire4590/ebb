class Board < ActiveRecord::Base
  attr_accessible :height, :name, :timezone, :width
	attr_protected :user_id

	has_many :tiles, through: :advertisements
	has_many :advertisements
	belongs_to :user
	has_one :payment_detail, as: :payable

	validates :name, presence: true,
			length: { minimum: 1 }
	validates :width, presence: true,
			:numericality => { :greater_than_or_equal_to => 1 }
	validates :height, presence: true,
			:numericality => { :greater_than_or_equal_to => 1 }
	validates :timezone, presence: true	
	validates_inclusion_of :timezone, 
			:in => ActiveSupport::TimeZone.zones_map(&:to_s)

	after_create :createFake

	def age
		# I don't know how to handle Timezone changes... When is this function called?
		# Cannot test function until the function is actually called...
		@tiles = board.tiles
		finalProfit = 0
		@tiles.each do |tile|
			finalProfit = finalProfit + tile.cost
		end
		finalProfit = (finalProfit/2).to_f
		boardCost = (width * height).to_f
		finalCost = (boardCost - finalProfit).to_f
		@paymentDetail = create_payment_detail(amount: finalCost)
		@paymentDetail.user = user
	end
	
	def createFake
		@advertisement = advertisements.build(width: width, height: height, x_location: 0, y_location: 0, image: "default_text.jpg")
		@advertisement.user = user
		@paymentDetail = create_payment_detail(amount: width * height)
		@paymentDetail.user = user
	end


end
