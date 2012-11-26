require 'spec_helper'
include ActionView::Helpers::TextHelper # for pluralize

describe "BoardPages" do
  subject { page }

  describe 'listing' do
    before do
      30.times { FactoryGirl.create(:board) }
      visit boards_path
    end

    it 'should list all the boards' do
      Board.all.each {|b| should have_link(b.name, href: board_path(b)) }
    end
  end

  describe 'display' do
    let(:board) { FactoryGirl.create(:board) }

    before { visit board_path(board) }

    it { should have_content(board.name) }
    it { should have_content("Height: #{pluralize board.height, 'tile'}") }
    it { should have_content("Width: #{pluralize board.width, 'tile'}") }
    it { should have_content("Created by: #{board.user.name}") }
    it { should have_content(board.timezone) }
    it { should have_button('Create advertisement') }
  end

  describe 'create new board' do
    let(:user) { FactoryGirl.create(:user) }
    let(:submit) { 'Create board' }

    before do
      signin user
      visit new_board_path
    end

    describe 'with missing information' do
      it 'should not create a board' do
	expect { click_button submit }.not_to change(Board, :count)
      end

      describe 'after submission' do
	before { click_button submit }

	it { should have_error }
      end
    end

    describe 'with valid information' do
      before do
	fill_in 'Height', with: 10
	fill_in 'Width', with: 15
	select 'Eastern Time (US & Canada)'
	fill_in 'Name', with: 'New Board'
      end

      it 'should create a board' do
	expect { click_button submit }.to change(Board, :count).by(1)
      end

      it 'should create a payment detail' do
	expect { click_button submit }.to change(PaymentDetail, :count).by(1)
      end

      describe 'after saving the board' do
	before { click_button submit }

	let(:board) { Board.find_by_name('New Board') }
	let(:pd) { board.payment_detail }

	specify { board.user.should == user }
	specify { pd.amount.should == board.width * board.height }
	it { should have_success('Board created') }
	it { should have_content(board.name) }
	it { should have_content(board.width) }
	it { should have_content(board.height) }
	it { should have_content(board.timezone) }
	it { should have_content(board.user.name) }
      end
    end
  end
end
