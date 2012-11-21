require 'spec_helper'

describe "StaticPages" do
  subject { page }

  describe 'Home page' do
    before { visit root_path }

    it { should_not have_content('Rails') }
    it { should have_content('Electronic Bulletin Board') }

    it 'should not be accessible via some other route' do
      expect do
	visit 'static_pages#index'
      end.to raise_error

      expect do
	visit 'static_pages#home'
      end.to raise_error
    end
  end

  describe 'Sign up page' do
    before { visit signup_path }

    it { should have_content('Sign up') }
    it { should have_button('Sign up') }
  end

  describe 'Sign in page' do
    before { visit signin_path }

    it { should have_content('Sign in') }
    it { should have_button('Sign in') }
  end
end
