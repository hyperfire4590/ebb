class ImagesController < ApplicationController
	
	def show
		@advertisement = Advertisement.find(params[:id])
		send_data(@advertisement.image, :disposition => "follow")
	end
	
	
end
