# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ShibbolethAttributeReader, type: :model do
  it 'reads canonical HTTP_* shibboleth headers' do
    env = {
      'HTTP_EPPN' => 'canonical@uc.edu',
      'HTTP_MAIL' => 'canonical@uc.edu',
      'HTTP_GIVENNAME' => 'Canonical',
      'HTTP_SN' => 'User'
    }

    attributes = described_class.new(env).attributes

    expect(attributes[:eppn]).to eq('canonical@uc.edu')
    expect(attributes[:email]).to eq('canonical@uc.edu')
    expect(attributes[:first_name]).to eq('Canonical')
    expect(attributes[:last_name]).to eq('User')
  end

  it 'supports REDIRECT_HTTP_* values when headers are rewritten' do
    env = {
      'REDIRECT_HTTP_EPPN' => 'redirect@uc.edu',
      'REDIRECT_HTTP_MAIL' => 'redirect@uc.edu',
      'REDIRECT_HTTP_GIVENNAME' => 'Redirect',
      'REDIRECT_HTTP_SN' => 'User'
    }

    attributes = described_class.new(env).attributes

    expect(attributes[:eppn]).to eq('redirect@uc.edu')
    expect(attributes[:email]).to eq('redirect@uc.edu')
    expect(attributes[:first_name]).to eq('Redirect')
    expect(attributes[:last_name]).to eq('User')
  end

  it 'supports trusted unscoped env values used by some shibboleth modules' do
    env = {
      'eppn' => 'env@uc.edu',
      'mail' => 'env@uc.edu',
      'givenName' => 'Env',
      'sn' => 'User'
    }

    attributes = described_class.new(env).attributes

    expect(attributes[:eppn]).to eq('env@uc.edu')
    expect(attributes[:email]).to eq('env@uc.edu')
    expect(attributes[:first_name]).to eq('Env')
    expect(attributes[:last_name]).to eq('User')
  end
end
