class Board < ActiveRecord::Base
  attr_accessible :height, :name, :timezone, :user_id, :width

	has_mnany :tiles
	has_many :advertisements
	belongs_to :user
end
