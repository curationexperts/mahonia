# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MahoniaCsvParser do
  subject(:parser) { described_class.new(file: file) }
  let(:file)       { File.open(csv_path) }
  let(:csv_path)   { 'spec/fixtures/bepress_etd_sample.csv' }

  describe '#records' do
    it 'skips records with no values' do
      expect(parser.records.count).to eq 3
    end
  end

  describe '#validate' do
    it 'is valid' do
      expect(parser.validate).to be_truthy
    end

    context 'with invalid csv' do
      let(:csv_path) { 'spec/fixtures/malformed.csv' }

      it 'has CSV::MalformedCSVError error' do
        expect { parser.validate }
          .to change { parser.errors }
          .to include have_attributes(name: CSV::MalformedCSVError)
      end
    end
  end
end
