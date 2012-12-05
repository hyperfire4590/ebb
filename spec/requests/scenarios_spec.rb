require 'spec_helper'

describe "Scenarios" do
  shared_examples 'an advertisement display' do
   describe 'in browser', js: true do
    specify { "#{64 * ad.x_location}px".should eql_element_property_value("img#ad_#{ad.id}_image", 'left') }
    specify { "#{64 * ad.y_location}px".should eql_element_property_value("img#ad_#{ad.id}_image", 'top') }
    specify { ad.id.to_s.should eql_element_property_value("img#ad_#{ad.id}_image", 'z-index') }
   end
  end

  describe 'two advertisements side-by-side' do
    let(:board) { FactoryGirl.create(:board, width: 10, height: 10) }
    let!(:ad1) { FactoryGirl.create(:advertisement,
				    x_location: 0,
				    y_location: 0,
				    width: 2,
				    height: 2,
				    board: board) }
    let!(:ad2) { FactoryGirl.create(:advertisement,
				    x_location: 2,
				    y_location: 0,
				    width: 3,
				    height: 3,
				    board: board) }

    before { visit board_path(board) }

    specify { page.all('.ad_container img').count.should == 3 }
    it_behaves_like 'an advertisement display' do
      let(:ad) { ad1 }
    end
    it_behaves_like 'an advertisement display' do
      let(:ad) { ad2 }
    end

    specify { ad1.tiles.count.should == 2 * 2 }
    specify { ad2.tiles.count.should == 3 * 3 }
  end

  describe 'two advertisements partially overlapping' do
    let(:board) { FactoryGirl.create(:board, width: 10, height: 10) }
    let!(:ad1) { FactoryGirl.create(:advertisement,
				    x_location: 3,
				    y_location: 3,
				    width: 4,
				    height: 4,
				    board: board) }
    let!(:ad2) { FactoryGirl.create(:advertisement,
				    x_location: 5,
				    y_location: 5,
				    width: 4,
				    height: 4,
				    board: board) }

    before { visit board_path(board) }

    specify { page.all('.ad_container img').count.should == 3 }
    it_behaves_like 'an advertisement display' do
      let(:ad) { ad1 }
    end
    it_behaves_like 'an advertisement display' do
      let(:ad) { ad2 }
    end

    specify { ad1.tiles.count.should == 4 * 4 - 2 * 2 }
    specify { ad2.tiles.count.should == 4 * 4 }
    specify { ad1.payment_details.last.amount.should == 4 * 4 }
    specify { ad2.payment_details.last.amount.should == 4 * 4 + 2 * 2 }
  end

  describe 'two advertisements fully overlapping' do
    let(:board) { FactoryGirl.create(:board) }
    let!(:ad1) { FactoryGirl.create(:advertisement,
				    x_location: 2,
				    y_location: 2,
				    width: 2,
				    height: 2,
				    board: board) }
    let!(:ad2) { FactoryGirl.create(:advertisement,
				    x_location: 2,
				    y_location: 2,
				    width: 2,
				    height: 2,
				    board: board) }

    before { visit board_path(board) }

    specify { page.all('.ad_container img').count.should == 2 }
    specify { page.should_not have_selector("ad_#{ad1.id}_image") }
    it_behaves_like 'an advertisement display' do
      let(:ad) { ad2 }
    end

    specify { ad1.tiles.count.should == 0 }
    specify { ad2.tiles.count.should == 2 * 2 }
    specify { ad1.payment_details.last.amount.should == 2 * 2 }
    specify { ad2.payment_details.last.amount.should == 2 * 2 * 2 }
  end

  describe 'first advertisement' do
    let(:board) { FactoryGirl.create(:board) }
    let!(:ad1) { FactoryGirl.create(:advertisement,
				    x_location: 5,
				    y_location: 2,
				    width: 3,
				    height: 3,
				    board: board) }

    before { visit board_path(board) }

    specify { page.all('.ad_container img').count.should == 2 }
    it_behaves_like 'an advertisement display' do
      let(:ad) { ad1 }
    end

    specify { ad1.tiles.count.should == 3 * 3 }

    describe 'one day later' do
      before { board.age }

      specify { ad1.payment_details.last.amount.should == 3 * 3 / 2.0 }

      describe 'second advertisement (partial overlap)' do
	let!(:ad2) { FactoryGirl.create(:advertisement,
					x_location: 2,
					y_location: 2,
					width: 4,
					height: 6,
					board: board) }

	before { visit board_path(board) }

	specify { page.all('.ad_container img').count.should == 3 }
	it_behaves_like 'an advertisement display' do
	  let(:ad) { ad1 }
	end
	it_behaves_like 'an advertisement display' do
	  let(:ad) { ad2 }
	end

	specify { ad1.tiles.count.should == 3 * 3 - 3 }
	specify { ad2.tiles.count.should == 4 * 6 }
	specify { ad2.payment_details.last.amount.should == 4 * 6 }
      end

      describe 'second advertisement (complete overlap)' do
	let!(:ad2) { FactoryGirl.create(:advertisement,
					x_location: 5,
					y_location: 2,
					width: 3,
					height: 3,
					board: board) }

	before { visit board_path(board) }

	specify { page.all('.ad_container img').count.should == 2 }
	it_behaves_like 'an advertisement display' do
	  let(:ad) { ad2 }
	end

	specify { ad1.tiles.count.should == 0 }
	specify { ad2.tiles.count.should == 3 * 3 }
	specify { ad2.payment_details.last.amount.should == 3 * 3 }
      end
    end

    describe 'after ad expires' do
      before { 10.times { board.age } }

      specify { ad1.payment_details.last.amount.should == 3 * 3 * 0.01 }
      specify { ad1.payment_details.count.should == 8 }

      describe 'second advertisement (partial overlap)' do
	let!(:ad2) { FactoryGirl.create(:advertisement,
					x_location: 2,
					y_location: 2,
					width: 4,
					height: 6,
					board: board) }

	before { visit board_path(board) }

	specify { page.all('.ad_container img').count.should == 3 }
	it_behaves_like 'an advertisement display' do
	  let(:ad) { ad1 }
	end
	it_behaves_like 'an advertisement display' do
	  let(:ad) { ad2 }
	end

	specify { ad1.tiles.count.should == 3 * 3 - 3 }
	specify { ad2.tiles.count.should == 4 * 6 }
	specify { ad2.payment_details.last.amount.should == 4 * 6 }
      end

      describe 'second advertisement (complete overlap)' do
	let!(:ad2) { FactoryGirl.create(:advertisement,
					x_location: 5,
					y_location: 2,
					width: 3,
					height: 3,
					board: board) }

	before { visit board_path(board) }

	specify { page.all('.ad_container img').count.should == 2 }
	it_behaves_like 'an advertisement display' do
	  let(:ad) { ad2 }
	end

	specify { ad1.tiles.count.should == 0 }
	specify { ad2.tiles.count.should == 3 * 3 }
	specify { ad2.payment_details.last.amount.should == 3 * 3 }
      end
    end
  end

  describe 'advertisements on different boards' do
    let(:board1) { FactoryGirl.create(:board) }
    let(:board2) { FactoryGirl.create(:board) }
    let!(:ad1) { FactoryGirl.create(:advertisement, board: board1) }
    let!(:ad2) { FactoryGirl.create(:advertisement, board: board2) }

    describe 'board1' do
      before { visit board_path(board1) }

      specify { page.all('.ad_container img').count.should == 2 }
      it_behaves_like 'an advertisement display' do
	let(:ad) { ad1 }
      end

      specify { ad1.payment_details.last.amount.should == ad1.width * ad1.height }
    end

    describe 'board2' do
      before { visit board_path(board2) }

      specify { page.all('.ad_container img').count.should == 2 }
      it_behaves_like 'an advertisement display' do
	let(:ad) { ad2 }
      end

      specify { ad2.payment_details.last.amount.should == ad2.width * ad2.height }
    end
  end

  describe 'one advertisment overlapping two other ads' do
    let(:board) { FactoryGirl.create(:board) }
    let!(:ad1) { FactoryGirl.create(:advertisement,
				    x_location: 2,
				    y_location: 2,
				    width: 4,
				    height: 4,
				    board: board) }
    let!(:ad2) { FactoryGirl.create(:advertisement,
				    x_location: 7,
				    y_location: 7,
				    width: 2,
				    height: 2,
				    board: board) }
    let!(:ad3) { FactoryGirl.create(:advertisement,
				    x_location: 4,
				    y_location: 4,
				    width: 4,
				    height: 4,
				    board: board) }

    before { visit board_path(board) }

    specify { page.all('.ad_container img').count.should == 4 }
    it_behaves_like 'an advertisement display' do
      let(:ad) { ad1 }
    end
    it_behaves_like 'an advertisement display' do
      let(:ad) { ad2 }
    end
    it_behaves_like 'an advertisement display' do
      let(:ad) { ad3 }
    end

    specify { ad1.tiles.count.should == 4 * 4 - 2 * 2 }
    specify { ad2.tiles.count.should == 2 * 2 - 1 }
    specify { ad3.tiles.count.should == 4 * 4 }

    specify { ad1.payment_details.last.amount.should == 4 * 4 }
    specify { ad2.payment_details.last.amount.should == 2 * 2 }
    specify { ad3.payment_details.last.amount.should == 4 * 4 + 2 * 2 + 1 }
  end

  #
  # order matters
  #
  describe 'one advertisment overlapped by two other ads' do
    let(:board) { FactoryGirl.create(:board) }
    let!(:ad1) { FactoryGirl.create(:advertisement,
				    x_location: 4,
				    y_location: 4,
				    width: 4,
				    height: 4,
				    board: board) }
    let!(:ad2) { FactoryGirl.create(:advertisement,
				    x_location: 2,
				    y_location: 2,
				    width: 4,
				    height: 4,
				    board: board) }
    let!(:ad3) { FactoryGirl.create(:advertisement,
				    x_location: 7,
				    y_location: 7,
				    width: 2,
				    height: 2,
				    board: board) }

    before { visit board_path(board) }

    specify { page.all('.ad_container img').count.should == 4 }
    it_behaves_like 'an advertisement display' do
      let(:ad) { ad1 }
    end
    it_behaves_like 'an advertisement display' do
      let(:ad) { ad2 }
    end
    it_behaves_like 'an advertisement display' do
      let(:ad) { ad3 }
    end

    specify { ad1.tiles.count.should == 4 * 4 - 2 * 2 - 1 }
    specify { ad2.tiles.count.should == 4 * 4 }
    specify { ad3.tiles.count.should == 2 * 2 }

    specify { ad1.payment_details.last.amount.should == 4 * 4 }
    specify { ad2.payment_details.last.amount.should == 4 * 4 + 2 * 2 }
    specify { ad3.payment_details.last.amount.should == 2 * 2 + 1 }
  end

  describe 'one advertisement covered by another covered by another' do
    let(:board) { FactoryGirl.create(:board) }
    let!(:ad1) { FactoryGirl.create(:advertisement,
				    x_location: 2,
				    y_location: 3,
				    width: 4,
				    height: 5,
				    board: board) }
    let!(:ad2) { FactoryGirl.create(:advertisement,
				    x_location: 2,
				    y_location: 3,
				    width: 4,
				    height: 5,
				    board: board) }
    let!(:ad3) { FactoryGirl.create(:advertisement,
				    x_location: 2,
				    y_location: 3,
				    width: 4,
				    height: 5,
				    board: board) }

    before { visit board_path(board) }

    specify { page.all('.ad_container img').count.should == 2 }
    it_behaves_like 'an advertisement display' do
      let(:ad) { ad3 }
    end

    specify { ad1.tiles.count.should == 0 }
    specify { ad2.tiles.count.should == 0 }
    specify { ad3.tiles.count.should == 4 * 5 }

    specify { ad1.payment_details.last.amount.should == 4 * 5 }
    specify { ad2.payment_details.last.amount.should == 4 * 5 * 2 }
    specify { ad3.payment_details.last.amount.should == 4 * 5 * 2 * 2 }
  end

  describe 'single tile advertisement' do
    let(:ad) { FactoryGirl.create(:advertisement, width: 1, height: 1) }

    before { visit board_path(ad.board) }

    specify { page.all('.ad_container img').count.should == 2 }
    it_behaves_like 'an advertisement display'
    specify { ad.tiles.count.should == 1 }
    specify { ad.payment_details.last.amount.should == 1 }
  end

  describe 'full board advertisement' do
    let(:board) { FactoryGirl.create(:board) }
    let!(:ad) { FactoryGirl.create(:advertisement,
				   x_location: 0,
				   y_location: 0,
				   width: board.width,
				   height: board.height,
				   board: board) }

    before { visit board_path(board) }

    specify { page.all('.ad_container img').count.should == 1 }
    it_behaves_like 'an advertisement display'
    specify { ad.tiles.count.should == board.width * board.height }
    specify { ad.payment_details.last.amount.should == board.width * board.height }
  end
end
