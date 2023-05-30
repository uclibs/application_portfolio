# frozen_string_literal: true

RSpec.describe 'devise/mailer/reset_password_instructions.html.erb', type: :view do
  let(:user) { FactoryBot.create(:viewer) }
  let(:token) { 'example_reset_password_token' }

  before do
    assign(:resource, user)
    assign(:token, token)
    ENV['APP_PORTFOLIO_PRODUCTION_MAILER_URL'] = 'libapps.libraries.uc.edu'
  end

  it 'renders the email message' do
    render

    expect(rendered).to include("Hello #{user.email}!")
    expect(rendered).to include('Someone has requested a link to change your password. You can do this through the link below.')
    expect(rendered).to include("https://libapps.libraries.uc.edu/users/password/edit?reset_password_token=#{token}")
    expect(rendered).to include('Change my password')
    expect(rendered).to include("If you didn't request this, please ignore this email.")
    expect(rendered).to include('Your password won\'t change until you access the link above and create a new one.')
  end
end
