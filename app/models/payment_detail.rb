class PaymentDetail < ActiveRecord::Base
  attr_accessible :amount, :payable_id, :payable_type, :user_id

	belongs_to :payable, polymorphic: true
	belongs_to :user
end
