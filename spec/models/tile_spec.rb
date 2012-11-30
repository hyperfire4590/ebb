require 'spec_helper'

describe Tile do
  let(:user) { FactoryGirl.create(:user) }
  let(:board) { FactoryGirl.create(:board, user: user) }
  let(:ad) { FactoryGirl.create(:advertisement, user: user, board: board) }
  let(:tile) { FactoryGirl.create(:tile, advertisement: ad) }

  subject { tile }

  it { should respond_to(:board) }
  it { should respond_to(:advertisement) }
  it { should respond_to(:advertisement_id) }
  it { should respond_to(:x_location) }
  it { should respond_to(:y_location) }
  it { should respond_to(:cost) }
  it { should respond_to(:age) }

  describe 'accessible attributes' do
    it 'should not allow access to board_id' do
      expect do
	Tile.new(board_id: board)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end

    it 'should not allow access to advertisement_id' do
      expect do
	Tile.new(advertisement_id: ad)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end

    it 'should not allow access to cost' do
      expect do
	Tile.new(cost: 1)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end

  #
  # It is important to note that because FactoryGirl creates the
  # objects in the DB, it expects them to validate successfully before
  # returning.  This is important with let since we are lazily
  # creating our objects, so the first time we see an object it is
  # also being created for us.  We need to be sure that the order we
  # list the objects will ensure they remain valid upon creation.  We
  # could solve this by using build instead of create, but I expect
  # we'll want truly created objects for future tests.  In the
  # meantime, if we put tile before manipulating board, ad, or user,
  # then things should "just work".
  #
  describe 'validating attributes' do
    describe 'x_location' do
      describe 'nil' do
	before { tile.x_location = nil }

	it { should_not be_valid }
      end

      describe 'blank' do
	before { tile.x_location = '' }

	it { should_not be_valid }
      end

      describe 'text' do
	before { tile.x_location = 'text' }

	it { should_not be_valid }
      end

      describe 'negative' do
	before { tile.x_location = -1 }

	it { should_not be_valid }
      end

      describe 'larger than board width' do
	before do
	  tile.x_location = 5
	  tile.board.width = 5
	end

	it { should_not be_valid }
      end

      describe 'smaller than ad x_location' do
	before do
	  tile.x_location = 7
	  ad.x_location = 9
	end

	it { should_not be_valid }
      end

      describe 'past end of ad width' do
	before do
	  tile.x_location = 4
	  ad.x_location = 0
	  ad.width = 4
	end

	it { should_not be_valid }
      end
    end

    describe 'y_location' do
      describe 'nil' do
	before { tile.y_location = nil }

	it { should_not be_valid }
      end

      describe 'blank' do
	before { tile.y_location = '' }

	it { should_not be_valid }
      end

      describe 'text' do
	before { tile.y_location = 'text' }
      end

      describe 'negative' do
	before { tile.y_location = -1 }

	it { should_not be_valid }
      end

      describe 'larger than board height' do
	before do
	  tile.y_location = 5
	  tile.board.height = 5
	end

	it { should_not be_valid }
      end

      describe 'smaller than ad y_location' do
	before do
	  tile.y_location = 7
	  ad.y_location = 9
	end

	it { should_not be_valid }
      end

      describe 'past end of ad height' do
	before do
	  tile.y_location = 4
	  ad.y_location = 0
	  ad.height = 4
	end

	it { should_not be_valid }
      end
    end

    describe 'cost' do
      describe 'nil' do
	before { tile.cost = nil }

	it { should_not be_valid }
      end

      describe 'blank' do
	before { tile.cost = '' }

	it { should_not be_valid }
      end

      describe 'text' do
	before { tile.cost = 'text' }

	it { should_not be_valid }
      end

      describe 'negative' do
	before { tile.cost = -1 }

	it { should_not be_valid }
      end
    end
  end
end
