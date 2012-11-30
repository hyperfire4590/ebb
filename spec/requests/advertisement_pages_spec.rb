require 'spec_helper'

describe "AdvertisementPages" do
  subject { page }

  describe 'create new advertisement' do
    let(:user) { FactoryGirl.create(:user) }
    let(:board) { FactoryGirl.create(:board) }
    let(:submit) { 'Create advertisement' }

    before do
      signin user
      visit new_board_advertisement_path(board)
    end

    describe 'with missing information' do
      it 'should not create an advertisment' do
	expect { click_button submit }.not_to change(Advertisement, :count)
      end

      describe 'after submission' do
	before { click_button submit }

	it { should have_error }
      end
    end

    describe 'with valid information' do
      before do
	fill_in 'Height', with: 3
	fill_in 'Width', with: 5
	fill_in 'X Location', with: 1
	fill_in 'Y Location', with: 2
	attach_file 'advertisement_image_contents', Rails.root.join('spec', 'images', '3x5.jpg')
      end

      it 'should create an advertisment' do
	expect { click_button submit }.to change(Advertisement, :count).by(1)
      end

      it 'should create a payment detail' do
	expect { click_button submit }.to change(PaymentDetail, :count).by(1)
      end

      it 'should create width x height tiles' do
	expect do
	  click_button submit
	end.to change { Tile.last.id }.by(15)
      end

      describe 'after saving the advertisment' do
	let(:ad) { Advertisement.last }
	let(:payment) { ad.payment_details.last }

	before { click_button submit }

	specify { ad.board.should == board }
	specify { ad.user.should == user }
	specify { payment.amount.should == ad.width * ad.height }

	it { should have_success('Advertisement created') }
	it { should have_content(ad.width) }
	it { should have_content(ad.height) }
	it { should have_content(ad.x_location) }
	it { should have_content(ad.y_location) }
	it { should have_content(ad.user.name) }
	it { should have_selector("img#ad_#{ad.id}_image") }
      end
    end
  end

  describe 'having an advertisement age' do
    let!(:ad) { FactoryGirl.create(:advertisement, height: 4, width: 4) }
    let(:payment) { ad.payment_details.last }

    #
    # This test requires that the ad is not lazily loaded.  If it
    # were, then the test would have to know how many payment details
    # would be created from creation of the ad, board, and aging (3 by
    # my calculation), but isn't the main point of this test:  that
    # aging should cause one new payment detail for the only
    # advertisement on the board.
    #
    it 'should add a new payment detail' do
      expect { ad.board.age }.to change(PaymentDetail, :count).by(1)
    end

    describe 'should reduce in cost by half' do
      before { ad.board.age }

      specify { payment.amount.should == 4 * 4 / 2 }
    end

    describe 'tiles should never cost less than $0.01' do
      before { 7.times { ad.board.age } }

      specify { payment.amount.should == 4 * 4 * 0.01 }

      it 'should not add new payment details' do
	expect { ad.board.age }.not_to change(PaymentDetail, :count)
      end
    end
  end
end
