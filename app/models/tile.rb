class Tile < ActiveRecord::Base
  attr_accessible :x_location, :y_location
	attr_protected :cost, :board_id, :advertisement_id
	
	belongs_to :advertisement
	has_one :board, through: :advertisement

	validates :x_location, presence: true,
		:numericality => { :greater_than_or_equal_to => 0 }	
	validates :y_location, presence: true,
		:numericality => { :greater_than_or_equal_to => 0 }
	validates :cost, presence: true,
		:numericality => { :greater_than_or_equal_to => 0 }

end
