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

      describe 'after saving the advertisment' do
	let(:ad) { Advertisement.find_by_board_id(board) }

	before { click_button submit }

	specify { ad.board.should == board }
	specify { ad.user.should == user }
	specify { ad.payment_details.first.amount.should == ad.width * ad.height }
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
end
