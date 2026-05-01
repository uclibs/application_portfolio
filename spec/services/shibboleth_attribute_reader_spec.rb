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

  it 'ignores REDIRECT_HTTP_* values when canonical-only mode is enabled' do
    env = {
      'REDIRECT_HTTP_EPPN' => 'redirect@uc.edu',
      'REDIRECT_HTTP_MAIL' => 'redirect@uc.edu',
      'REDIRECT_HTTP_GIVENNAME' => 'Redirect',
      'REDIRECT_HTTP_SN' => 'User'
    }

    attributes = described_class.new(env).attributes

    expect(attributes[:eppn]).to be_nil
    expect(attributes[:email]).to be_nil
    expect(attributes[:first_name]).to be_nil
    expect(attributes[:last_name]).to be_nil
  end

  it 'ignores unscoped env values when canonical-only mode is enabled' do
    env = {
      'eppn' => 'env@uc.edu',
      'mail' => 'env@uc.edu',
      'givenName' => 'Env',
      'sn' => 'User'
    }

    attributes = described_class.new(env).attributes

    expect(attributes[:eppn]).to be_nil
    expect(attributes[:email]).to be_nil
    expect(attributes[:first_name]).to be_nil
    expect(attributes[:last_name]).to be_nil
  end

  it 'can accept legacy header variants when explicitly allowed for rollback' do
    env = {
      'REDIRECT_HTTP_EPPN' => 'redirect@uc.edu',
      'REDIRECT_HTTP_MAIL' => 'redirect@uc.edu',
      'REDIRECT_HTTP_GIVENNAME' => 'Redirect',
      'REDIRECT_HTTP_SN' => 'User'
    }

    attributes = described_class.new(env, allow_legacy_env_keys: true).attributes

    expect(attributes[:eppn]).to eq('redirect@uc.edu')
    expect(attributes[:email]).to eq('redirect@uc.edu')
    expect(attributes[:first_name]).to eq('Redirect')
    expect(attributes[:last_name]).to eq('User')
  end
end
