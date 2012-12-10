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

	after_create :createTiles

	def createTiles
		for x in x_location..(x_location + width-1) do
			for y in y_location..(x_location + height-1) do
				exist = board.tiles.where(x_location: x, y_location: y).first
				if exist.nil?
					@tile = tiles.build(x_location: x, y_location: y)
					theCost = 0
					@tile.cost = theCost.to_f
					@tile.save
				else
					oldCost = exist.cost
					exist.destroy
					replace = tiles.build(x_location: x, y_location: y)
					newCost = oldCost * 2
					if newCost < 1
						newCost = 1
					end
					replace.cost = newCost.to_f
					replace.save
					#exist.advertisement_id = id
					#@tile = tiles.build(x_location: x, y_location: y)
					
					#@tile = @advertisement.tiles.create(x_location: x, y_location: y)
					#@tile.cost = costFunction(@tile)
					#puts("Tile: ", x, y)
					#@tile.save
				end
				#puts("Tile: ", x, y)
			end
		end
	end

	def charge
		# write a function here
		@ads = advertisement.tiles
		finalCost = 0
		@ads.each do |tile|
			finalCost = finalCost + tile.cost
		end
		finalCost = finalCost.to_f
		@paymentDetail = create_payment_detail(amount: finalCost)
		@paymentDetail.user = user
	end
	
	
	def image_contents=(myImage)
		self.image = myImage.read
	end

	# Not Used Currently
	def costFunction(tile)
		x = tile.x_location
		y = tile.y_location
		@advertisement = Advertisement.find_by_id(tile.advertisement_id)
		@oldTile = @advertisement.tiles.first
		#.where("x_location = ? AND y_location = ?", x, y).first
		oldCost = @oldTile.cost.to_f * 2
		if oldCost < 1
			oldCost = 1
		end
		oldCost
	end

	private

		def check_advertisement_bounds
			unless x_location.nil?
				if board.width <= x_location
					errors.add(:x_location, 
						"Board width is less than or equal to x_location.")
				end
				if board.width < x_location + width
					errors.add(:width, 
						"Board width is less than or equal to x_location plus width.")
				end
			end
			
			unless y_location.nil?
				if board.height <= y_location
					errors.add(:y_location,
						"Board height is less than or equal to y_location.")
				end
				if board.height < y_location + height
					errors.add(:height, 
						"Board height is less than or equal to y_location plus height.")
				end
			end	
			
		end

end
