class AdvertisementsController < ApplicationController

before_filter :signed_in_user, only: [:new, :create]

	def new
		@board = Board.find(params[:board_id])
		@advertisement = Advertisement.new()
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

end
