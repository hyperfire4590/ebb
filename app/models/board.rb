class Board < ActiveRecord::Base
  attr_accessible :height, :name, :timezone, :user_id, :width

	has_many :tiles
	has_many :advertisements
	belongs_to :user
	has_one :payment_detail, as: :payable
end
