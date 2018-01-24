# frozen_string_literal: true
require 'rails_helper'

RSpec.describe RepresentativeFileValidator do
  it_behaves_like 'a Darlingtonia::Validator' do
    let(:invalid_parser) { MahoniaCsvParser.new(file: invalid_file) }
  end

  subject(:validator) { described_class.new }
  let(:parser)        { MahoniaCsvParser.new(file: file) }
  let(:file)          { File.open("#{fixture_path}/bepress_etd_sample.csv") }
  let(:invalid_file)  { File.open("#{fixture_path}/missing_file.csv") }

  context 'when records have files' do
    it 'is valid' do
      expect(validator.validate(parser: parser)).to be_empty
    end
  end

  context 'when records are missing representative files' do
    subject(:parser) { MahoniaCsvParser.new(file: invalid_file) }

    it 'is invalid' do
      expect(validator.validate(parser: parser))
        .to contain_exactly(have_attributes(name: :missing_file),
                            have_attributes(name: :missing_file),
                            have_attributes(name: :file_not_readable))
    end
  end
end
