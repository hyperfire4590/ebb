require 'spec_helper'

describe "UserPages" do
  subject { page }

  describe 'signup' do
    let(:submit) { 'Sign up' }

    before { visit signup_path }

    describe 'with invalid information' do
      it 'should not create a user' do
	expect { click_button submit }.not_to change(User, :count)
      end

      describe 'after submission' do
	before { click_button submit }

	it { should have_error }
      end
    end

    describe 'with valid information' do
      before do
	fill_in 'Name', with: 'Example User'
	fill_in 'Email', with: 'user@example.com'
	fill_in 'Password', with: 'foobar'
	fill_in 'Confirm Password', with: 'foobar'
      end

      it 'should create a user' do
	expect { click_button submit }.to change(User, :count).by(1)
      end

      describe 'after saving the user' do
	before { click_button submit }

	let(:user) { User.find_by_email('user@example.com') }

	it { should have_link('Sign out') }
	it { should have_success('Welcome') }
      end
    end
  end

  describe 'profile' do
    let(:user) { FactoryGirl.create(:user) }

    before { visit user_path(user) }

    it { should have_error('Not signed in') }
#    specify { response.should redirect_to(root_path) }

    describe 'after signing in' do
      before do
	signin user
	visit user_path(user)
      end

      it { should have_content(user.email) }
      it { should have_content(user.name) }
      it { should have_button('Create board') }
    end

  end

  describe 'user listing' do
    describe 'signed in as administrator' do
      let(:admin) { FactoryGirl.create(:admin) }
      let!(:user) { FactoryGirl.create(:user) }

      before do
	30.times { FactoryGirl.create(:user) }
	signin admin
	visit users_path
      end

      it 'should list all the users' do
	User.all.each {|u| should have_content(u.name)}
      end

      it { should_not have_link('delete', href: user_path(admin)) }
      it { should have_link('delete', href: user_path(user)) }

      it 'shouldn\'t allow self to be deleted' do
	expect { delete user_path(admin) }.not_to change(User, :count)
      end
      it 'should remove a user on deletion' do
	expect { click_link('delete') }.to change(User, :count).by(-1)
      end

#      describe 'it should warn about trying to delete admin' do
#	before { delete user_path(admin) }
#
#	it { should have_error('Cannot delete admin') }
#      end
#
#      describe 'it should notify about successful user deletion' do
#	before { delete user_path(user) }
#
#	it { should have_success('User deleted') }
#      end
    end
  end
end
