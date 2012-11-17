class User < ActiveRecord::Base
  attr_accessible :email, :name, :password_digest, :remember_token
	attr_protected :admin

	has_many :boards
	has_many :advertisements
	has_many :payment_details

	validates :name, presence: true, length: { maximum: 50 }
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true, 
			format: { with: VALID_EMAIL_REGEX },
			uniqueness: { case_sesitive: false }
end
