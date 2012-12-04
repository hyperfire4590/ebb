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
		    flash[:success] = "New Board"
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
	end
	
	def index
	end

	private
	
		def self.up
    	add_column :users, :time_zone, :string, :limit => 255, :default => "UTC"
  	end

end
