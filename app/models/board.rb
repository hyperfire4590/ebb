class Board < ActiveRecord::Base
  attr_accessible :height, :name, :timezone, :width
	attr_protected :user_id

	has_many :tiles
	has_many :advertisements
	belongs_to :user
	has_one :payment_detail, as: :payable

	validates :name, presence: true,
			length: { minimum: 1 }
	validates :width, presence: true,
			:numericality => { :greater_than_or_equal_to => 1 }
	validates :height, presence: true,
			:numericality => { :greater_than_or_equal_to => 1 }
	validates :timezone, presence: true	
	validates_inclusion_of :timezone, 
			:in => ActiveSupport::TimeZone.zones_map(&:to_s)


end
