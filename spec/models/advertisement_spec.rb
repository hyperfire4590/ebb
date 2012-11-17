require 'spec_helper'

describe Advertisement do
  let(:user) { FactoryGirl.create(:user) }
  let(:board) { FactoryGirl.create(:board) }
  let(:ad) { FactoryGirl.create(:advertisement, user: user, board: board) }

  subject { ad }

  it { should respond_to(:x_location) }
  it { should respond_to(:y_location) }
  it { should respond_to(:height) }
  it { should respond_to(:width) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  it { should respond_to(:board) }
  it { should respond_to(:board_id) }
  it { should respond_to(:image) }

  describe 'accessible attributes' do
    it 'should not allow access to user_id' do
      expect do
	Advertisement.new(user_id: user)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end

    it 'should not allow access to board_id' do
      expect do
	Advertisement.new(board_id: board)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end

  describe 'validating attributes' do
    describe 'x_location' do
      describe 'nil' do
	before { ad.x_location = nil }

	it { should_not be_valid }
      end

      describe 'blank' do
	before { ad.x_location = '' }

	it { should_not be_valid }
      end

      describe 'text' do
	before { ad.x_location = 'text' }

	it { should_not be_valid }
      end

      describe 'negative' do
	before { ad.x_location = -1 }

	it { should_not be_valid }
      end

      describe 'larger than board width' do
	before do
	  ad.x_location = 7
	  board.width = 7
	end

	it { should_not be_valid }
      end
    end

    describe 'y_location' do
      describe 'nil' do
      end

      describe 'blank' do
      end

      describe 'text' do
      end

      describe 'negative' do
	before { ad.y_location = -1 }

	it { should_not be_valid }
      end

      describe 'larger than board height' do
	before do
	  ad.y_location = 4
	  board.height = 4
	end

	it { should_not be_valid }
      end
    end

    describe 'height' do
      describe 'nil' do
      end

      describe 'blank' do
      end

      describe 'text' do
      end

      describe 'negative' do
	before { ad.height = -1 }

	it { should_not be_valid }
      end

      describe 'larger than board height' do
	before do
	  ad.height = 6
	  board.height = 5
	end

	it { should_not be_valid }
      end
    end

    describe 'width' do
      describe 'nil' do
      end

      describe 'blank' do
      end

      describe 'text' do
      end

      describe 'negative' do
	before { ad.width = -1 }

	it { should_not be_valid }
      end

      describe 'larger than board width' do
	before do
	  ad.width = 6
	  board.width = 6
	end

	it { should_not be_valid }
      end
    end

    describe 'image' do
      describe 'nil' do
	before { ad.image = nil }

	it { should_not be_valid }
      end
    end

    describe 'x_location & width' do
      describe 'combined larger than board width' do
	before do
	  ad.x_location = 3
	  ad.width = 4
	  board.width = 6
	end

	it { should_not be_valid }
      end
    end

    describe 'y_location & height' do
      describe 'combined larger than board height' do
	before do
	  ad.y_location = 4
	  ad.height = 5
	  board.height = 8
	end

	it { should_not be_valid }
      end
    end
  end
end
