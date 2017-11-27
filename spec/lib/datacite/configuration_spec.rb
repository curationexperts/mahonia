# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Datacite::Configuration do
  subject(:config) { described_class.instance }

  after(:all) do
    described_class
      .instance
      .load_from_hash Rails.application.config_for(:datacite)
  end

  it 'loads attributes from Rails config file' do
    expect(config).to have_attributes domains:  an_instance_of(String),
                                      login:    an_instance_of(String),
                                      password: an_instance_of(String),
                                      prefix:   an_instance_of(String)
  end

  describe '#load_from_hash' do
    let(:hash) do
      { 'domains'  => 'hash_domains',
        'login'    => 'hash_login',
        'password' => 'hash_password',
        'prefix'   => 'hash_prefix' }
    end

    it 'loads settings from the hash' do
      config.load_from_hash(hash)

      expect(config).to have_attributes hash
    end
  end

  context 'with manually set attributes' do
    before do
      config.domains  = 'domains'
      config.login    = 'login'
      config.password = 'password'
      config.prefix   = 'prefix'
    end

    it do
      is_expected.to have_attributes domains:  'domains',
                                     login:    'login',
                                     password: 'password',
                                     prefix:   'prefix'
    end
  end
end
