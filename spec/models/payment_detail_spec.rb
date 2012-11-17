require 'spec_helper'

describe PaymentDetail do
  let(:user) { FactoryGirl.create(:user) }
  let(:board) { FactoryGirl.create(:board, user: user) }
  let(:ad) { FactoryGirl.create(:advertisement, user: user, board: board) }
  let(:ad_payment) { FactoryGirl.create(:ad_payment, user: user) }
  let(:board_payment) { FactoryGirl.create(:board_payment, user: user) }

  specify { ad_payment.should respond_to(:user) }
  specify { ad_payment.should respond_to(:user_id) }
  specify { ad_payment.should respond_to(:payable) }
  specify { ad_payment.should respond_to(:amount) }

  specify { board_payment.should respond_to(:user) }
  specify { board_payment.should respond_to(:user_id) }
  specify { board_payment.should respond_to(:payable) }
  specify { board_payment.should respond_to(:amount) }

  describe 'accessible attributes' do
    it 'should not allow access to payable_id' do
      expect do
	PaymentDetail.new(payable_id: ad)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end

    it 'should not allow access to payable_type' do
      expect do
	PaymentDetail.new(payable_type: Advertisement)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end

    it 'should not allow access to user_id' do
      expect do
	PaymentDetail.new(user_id: user)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end

  describe 'validating attributes' do
    describe 'amount' do
      describe 'nil' do
	before { ad_payment.amount = nil }

	specify { ad_payment.should_not be_valid }
      end

      describe 'blank' do
	before { board_payment.amount = '' }

	specify { board_payment.should_not be_valid }
      end

      describe 'text' do
	before { ad_payment.amount = 'text' }

	specify { ad_payment.should_not be_valid }
      end
    end
  end
end
