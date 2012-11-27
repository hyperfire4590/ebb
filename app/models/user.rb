class User < ActiveRecord::Base
  attr_accessible :email, :name
	attr_protected :admin, :password_digest, :remember_token

	has_secure_password

	has_many :boards
	has_many :advertisements
	has_many :payment_details

	before_save { self.email.downcase! }


	validates :name, presence: true, length: { maximum: 50 }
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true, 
			format: { with: VALID_EMAIL_REGEX },
			uniqueness: { case_sensitive: false }
	
	validates :password, length: { minimum: 6 }
	validates :password_confirmation, presence: true
	#validates :remember_token, presence: true

end
