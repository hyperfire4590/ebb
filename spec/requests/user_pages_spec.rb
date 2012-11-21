require 'spec_helper'

describe "UserPages" do
  subject { page }

  describe 'signup' do
    before { visit signup_path }

    describe 'with invalid information' do
      it 'should not create a user' do
	expect { click_button 'Sign up' }.not_to change(User, :count)
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
	expect { click_button 'Sign up' }.to change(User, :count).by(1)
      end

      describe 'after saving the user' do
	before { click_button 'Sign up' }

	let(:user) { User.find_by_email('user@example.com') }

	it { should have_link('Sign out') }
	it { should have_success('Welcome') }
      end
    end
  end
end
