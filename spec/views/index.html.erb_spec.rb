require 'rails_helper'

describe 'front/index' do
	context 'when user is not logged in' do
		it 'displays a login link' do
			render
			expect(rendered).to have_link('Login', href: new_user_session_path)
		end
	end
end

describe 'front/index' do
	context 'when user is created' do
		let(:user) {FactoryGirl.create(:user)}

	before do
		sign_in user
	end
	it 'displays who is logged in' do
		render
		expect(rendered).to have_text('Logged in as random@gmail.com')
	end

	it 'displays a logout link' do
		render
		expect(rendered).to have_link('Logout', href: destroy_user_session_path)
	end
end
end
