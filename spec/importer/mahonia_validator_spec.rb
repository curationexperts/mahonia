# frozen_string_literal: true
require 'rails_helper'

RSpec.describe MahoniaValidator do
  it_behaves_like 'a Darlingtonia::Validator'
  let(:metadata) { { title: nil, publication_date: '2020' } }
  it "validates the presence of OHSU required metadata" do
    described_class.new.validate(metadata).each do |error|
      expect(error.description).to eq('title is required')
    end
  end
end
