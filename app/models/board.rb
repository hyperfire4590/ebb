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

	before_create :createFake
	
	def image_contents=(myImage)
		self.image = myImage.read
	end
	
	def createFake
		@advertisement = advertisements.build(width: width, height: height, x_location: 0, y_location: 0, image: "/app/assets/images/default_text.jpg")
		@advertisement.user = user
		@paymentDetail = PaymentDetail.create(amount: width*height) #, payable_id: board.id
		@paymentDetail.user = user
		@paymentDetail.payable_type = "board"
		@paymentDetail.payable_id = id
		@paymentDetail.save
	end


	def age
			# After much confusion, I think this might actually make sense...
		@tiles = tiles
		finalProfit = 0 # amount of money that the Board owner makes?
		@tiles.each do |tile|
			tile.age
			finalProfit = finalProfit + tile.cost
		end
		@advertisements = advertisements
		@advertisements.each do |ad|
			ad.charge
		end
		finalProfit = (finalProfit/2)
		#boardCost = (width * height)
		#finalCost = (boardCost - finalProfit)
		@paymentDetail = PaymentDetail.create(amount: finalProfit) #finalCost
		@paymentDetail.user = user
		@paymentDetail.payable_type = "board"
		@paymentDetail.payable_id = id
		@paymentDetail.save
	end

end
