require 'spec_helper'

describe "AuthorizationPages" do
  subject { page }

  shared_examples_for 'non-signed in' do
    it { should have_error('Not signed in') }
#    specify { response.should redirect_to(root_path) }
  end

  describe 'user profile access by different user' do
    let(:user) { FactoryGirl.create(:user) }
    let(:other_user) { FactoryGirl.create(:user) }

    before do
      signin user
      visit user_path(other_user)
    end

    it { should have_error('Wrong user') }
#    specify { response.should redirect_to(user_path(user)) }
  end

  describe 'user listing' do
    describe 'before signing in' do
      before { visit users_path }

      it_should_behave_like 'non-signed in'
    end

    describe 'signed in as regular user' do
      let(:user) { FactoryGirl.create(:user) }

      before do
	signin user
	visit users_path
      end

      it { should have_error('Not an administrator') }
#      specify { response.should redirect_to(user_path(user)) }
    end
  end

  describe 'board creation' do
    describe 'visiting board#new before signing in' do
      before { visit new_board_path }

      it_should_behave_like 'non-signed in'
    end

    describe 'visiting board#create before signing in' do
      before { post boards_path }

      specify { response.should redirect_to(root_path) }
    end
  end
end
