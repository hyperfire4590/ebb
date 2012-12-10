class BoardsController < ApplicationController

	before_filter :signed_in_user, only: [:edit, :update, :destroy]

	def new
		if signed_in?
			@board = Board.new
		else
			flash[:error] = "Not signed in"
  		redirect_to(root_path)
		end
	end
	
	def create
		if signed_in?
			@board = Board.new(params[:board])
			@board.user = current_user
			if @board.save
		    #@advertisement = @board.advertisements.create(width: @board.width, height: @board.height, x_location: 0, y_location: 0, user: current_user, image: "/app/assets/images/default_text.jpg")
		    #createTiles(@advertisement)
				flash[:success] = "Board created"
		    redirect_to @board
		  else
		  	flash[:error] = "Try again?"
		    render 'new'
		  end
		else
			flash[:error] = "Not signed in"
			redirect_to(root_path)
		end
	end
	
	def show
		@board = Board.find(params[:id])
		@user = current_user
	end
	
	def index
  		@boards = Board.all
	end
	

	private
	
		def self.up
			# This does something for creating the timezone dropdown
    	add_column :users, :time_zone, :string, :limit => 255, :default => "UTC"
  	end
  	
  	def createTiles(ad)
			for x in 0..ad.width-1
				for y in 0..ad.height-1
					@tile = ad.tiles.create(x_location: x, y_location: y)
					@tile.cost = 0
				
					if @tile.save
						flash[:success] = "Created tiles"
					else
						flash[:error] = "broken", x, y
					end
				end
			end
		end

end
