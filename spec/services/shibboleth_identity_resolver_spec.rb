# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ShibbolethIdentityResolver, type: :model do
  it 'returns both raw attributes and normalized identity' do
    env = {
      'HTTP_EPPN' => '(null)',
      'HTTP_MAIL' => 'Example.User@UC.EDU',
      'HTTP_GIVENNAME' => 'Example',
      'HTTP_SN' => 'User'
    }

    resolver = described_class.new(env: env)

    expect(resolver.raw_attributes).to eq(
      eppn: '(null)',
      email: 'Example.User@UC.EDU',
      first_name: 'Example',
      last_name: 'User'
    )
    expect(resolver.normalized_identity).to eq(
      eppn: 'example.user@uc.edu',
      email: 'example.user@uc.edu',
      first_name: 'Example',
      last_name: 'User'
    )
  end
end
