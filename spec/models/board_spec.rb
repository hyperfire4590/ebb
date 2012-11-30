require 'spec_helper'

describe Board do
  let(:user) { FactoryGirl.create(:user) }
  let(:board) { FactoryGirl.create(:board, user: user) }

  subject { board }

  it { should respond_to(:name) }
  it { should respond_to(:user) }
  it { should respond_to(:user_id) }
  it { should respond_to(:height) }
  it { should respond_to(:width) }
  it { should respond_to(:age) }

  describe 'accessible attributes' do
    it 'should not allow access to user_id' do
      expect do
	Board.new(user_id: user)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end

  describe 'validating attributes' do
    describe 'name' do
      describe 'nil' do
	before { board.name = nil }

	it { should_not be_valid }
      end

      describe 'blank' do
	before { board.name = '' }

	it { should_not be_valid }
      end
    end

    describe 'height' do
      describe 'nil' do
	before { board.height = nil }

	it { should_not be_valid }
      end

      describe 'blank' do
	before { board.height = '' }

	it { should_not be_valid }
      end

      describe 'text' do
	before { board.height = 'text' }

	it { should_not be_valid }
      end

      describe 'negative' do
	before { board.height = -1 }

	it { should_not be_valid }
      end

      describe 'zero' do
	before { board.height = 0 }

	it { should_not be_valid }
      end
    end

    describe 'width' do
      describe 'nil' do
	before { board.width = nil }

	it { should_not be_valid }
      end

      describe 'blank' do
	before { board.width = '' }

	it { should_not be_valid }
      end

      describe 'text' do
	before { board.width = 'text' }

	it { should_not be_valid }
      end

      describe 'negative' do
	before { board.width = -1 }

	it { should_not be_valid }
      end

      describe 'zero' do
	before { board.width = 0 }

	it { should_not be_valid }
      end
    end

    describe 'timezone' do
      describe 'nil' do
	before { board.timezone = nil }

	it { should_not be_valid }
      end

      describe 'blank' do
	before { board.timezone = '' }

	it { should_not be_valid }
      end

      describe 'garbage' do
	before { board.timezone = 'garbage' }

	it { should_not be_valid }
      end
    end
  end
end
