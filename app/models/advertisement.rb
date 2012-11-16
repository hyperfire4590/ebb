class Advertisement < ActiveRecord::Base
  attr_accessible :board_id, :height, :image, :user_id, :width, :x_location, :y_location

	has_many :tiles
	belongs_to :user
	belongs_to :board
end
