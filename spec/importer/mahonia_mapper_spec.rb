# frozen_string_literal: true
require 'rails_helper'

RSpec.describe MahoniaMapper do
  let(:bepress_hash) { { title: "Research", publisher: "Random House" } }

  # Given a hash from a BePress source, the MahoniaMapper
  # translates BePress keys to Hyrax attribute keys,
  # creates a new hash containing only the data
  # that matches Hyrax keys, and returns it.

  it "maps bepress terms to hyrax terms" do
    mapper = described_class.new
    mapper.metadata = bepress_hash

    expect(mapper.metadata).to eq(title: "Research")
  end

  it "rejects terms not found in BEPRESS_TERMS_MAP" do
    mapper = described_class.new
    mapper.metadata = bepress_hash

    expect(mapper.metadata).not_to include(publisher: "Random House")
  end
end
