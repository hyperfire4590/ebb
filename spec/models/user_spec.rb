require 'spec_helper'

describe User do
  let(:user) { FactoryGirl.create(:user) }

  subject { user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:admin?) }

  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:remember_token) }

  it { should respond_to(:boards) }
  it { should respond_to(:advertisements) }
  it { should respond_to(:payment_details) }

  describe 'accessible attributes' do
    it 'should not allow access to admin' do
      expect do
	User.new(admin: true)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end

    it 'should not allow access to password_digest' do
      expect do
	User.new(password_digest: 'digest')
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end

    it 'should not allow access to remember_token' do
      expect do
	User.new(remember_token: 'token')
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end

  describe 'validating attributes' do
    describe 'name' do
      describe 'nil' do
	before { user.name = nil }

	it { should_not be_valid }
      end

      describe 'blank' do
	before { user.name = '' }

	it { should_not be_valid }
      end
    end

    describe 'email' do
      describe 'nil' do
	before { user.email = nil }

	it { should_not be_valid }
      end

      describe 'blank' do
	before { user.email = '' }

	it { should_not be_valid }
      end

      describe 'already in use' do
	before do
	  @user_with_same_email = user.dup
	  @user_with_same_email.email.upcase!
	end

        specify { @user_with_same_email.save.should be_false }
      end
    end

    describe 'password and confirmation' do
      describe 'nil' do
	before { user.password_confirmation = user.password = nil }

	it { should_not be_valid }
      end

      describe 'blank' do
	before { user.password_confirmation = user.password = '' }

	it { should_not be_valid }
      end

      describe 'too short' do
	before { user.password_confirmation = user.password = 'a' * 5 }

	it { should_not be_valid }
      end

      describe 'not matching' do
	before do
	  user.password_confirmation = 'something'
	  user.password = 'otherthing'
	end

	it { should_not be_valid }
      end
    end

    describe 'remember_token' do
      specify { user.remember_token.should_not be_blank }
    end
  end

  describe 'administrator' do
    it { should_not be_admin }

    describe 'can be turned on explicitly' do
      before { user.admin = true }

      it { should be_admin }
    end
  end

  describe 'supports authentication' do
    let(:found_user) { User.find_by_email(user.email) }

    describe 'with valid password' do
      it { should == found_user.authenticate(user.password) }
    end

    describe 'with invalid password' do
      let(:user_for_invalid_password) { found_user.authenticate('invalid') }

      it { should_not == user_for_invalid_password }
      specify { user_for_invalid_password.should be_false }
    end
  end
end
