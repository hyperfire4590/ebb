class BoardsController < ApplicationController

	before_filter :signed_in_user, only: [:index, :edit, :update, :destroy]

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
			if @board.save
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
		# @user = User.find(params[:user_id])
		# probably need something about signed_in? here...
	end
	
	def index
	end

	private
	
		def self.up
			# This does something for creating the timezone dropdown
    	add_column :users, :time_zone, :string, :limit => 255, :default => "UTC"
  	end

end
