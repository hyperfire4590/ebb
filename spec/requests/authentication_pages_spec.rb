require 'spec_helper'

describe "AuthenticationPages" do
  subject { page }

  shared_examples_for 'failed login' do
    it { should have_content('Sign in') }
    it { should have_error('Invalid') }

    describe 'after visiting another page' do
      before { visit root_path }

      it { should_not have_error }
    end
  end

  shared_examples_for 'successful login' do
    it { should have_link('Sign out', href: signout_path) }
    it { should_not have_link('Sign in', href: signin_path) }

    describe 'followed by signout' do
      before { click_link 'Sign out' }

      it { should have_link('Sign in', href: signin_path) }
      it { should_not have_link('Sign out', href: signout_path) }
    end
  end

  describe 'sign in' do
    before { visit signin_path }

    describe 'with missing information' do
      before { click_button 'Sign in' }

      it_should_behave_like 'failed login'
    end

    describe 'with invalid information' do
      let(:user) { FactoryGirl.create(:user) }

      describe 'email bad' do
	before do
	  user.email = 'junk@example.com'
	  signin user
	end

	it_should_behave_like 'failed login'
      end

      describe 'password bad' do
	before do
	  user.password = 'password'
	  signin user
	end

	it_should_behave_like 'failed login'
      end
    end

    describe 'with valid information' do
      let(:user) { FactoryGirl.create(:user) }
      before { signin user }

      it_should_behave_like 'successful login'
    end

    describe 'with valid information--different email' do
      let(:user) { FactoryGirl.create(:user, email: 'strANGe@example.com') }
      before do
	user.email.upcase!
	signin user
      end

      it_should_behave_like 'successful login'
    end
  end
end
