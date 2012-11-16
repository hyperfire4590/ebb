require 'spec_helper'

describe User do
  let(:user) { FactoryGirl.create(:user) }

  subject { user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:admin?) }

  describe 'accessible attributes' do
    it 'should not allow access to admin' do
      expect do
	User.new(admin: true)
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
    end
  end
end
