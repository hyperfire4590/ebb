class TilesController < ApplicationController
	
	def new
		@advertisement = Advertisement.find(params[:advertisement_id])
		@tile = Tile.new
	end
	
	def create
		@advertisement = Advertisement.find(params[:advertisement_id])
		@tile = @advertisement.tile.build(params[:tile])
		#@tile = @advertisement.tile.build(x_location: x, y_location: y, board_id: @advertisement.board_id, advertisement_id: @advertisement.id, cost: 0)
		@tile.save
	end
	
	
end
