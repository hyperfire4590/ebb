class AdvertisementsController < ApplicationController

before_filter :signed_in_user, only: [:new, :create]

	def new
		@board = Board.find(params[:board_id])
		@advertisement = Advertisement.new
	end	
	
	def create
		@board = Board.find(params[:board_id])
		@advertisement = @board.advertisements.build(params[:advertisement])
		@advertisement.user = current_user
    if @advertisement.save
      flash[:success] = "Advertisement created!"
      redirect_to @board
    else
      flash[:error] = "Save failed."
      render 'new'
    end
  end

	private
	
		# Not currently Used
		def createTiles
			for x in @advertisement.x_location..(@advertisement.x_location+@advertisement.width-1)
				for y in @advertisement.y_location..(@advertisement.x_location+@advertisement.height)
					@tile = @advertisement.tiles.create(x_location: x, y_location: y)
					@tile.cost = costFunction(@tile)
					#puts("Tile: ", x, y)
				
					if @tile.save
						puts("tile id -----> ", @tile.id)
						puts("tile cost <<<< ", @tile.cost)
						flash[:success] = "Created tiles"
					else
						flash[:error] = "broken", x, y
					end
				end
			end
		end
	
		def costFunction(tile)
			x = tile.x_location
			y = tile.y_location
			@advertisement = Advertisement.find_by_id(tile.advertisement_id)
			@oldTile = @advertisement.tiles.first
			#.where("x_location = ? AND y_location = ?", x, y).first
			oldCost = @oldTile.cost * 2
			if oldCost < 1
				oldCost = 1
			end
			oldCost
		end

end
