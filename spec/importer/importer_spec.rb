# frozen_string_literal: true
require 'rails_helper'
RSpec.describe Importer do
  subject(:importer) { described_class.new(parser: parser) }
  let(:parser) { Darlingtonia::CsvParser.new(file: file) }
  let(:file) { File.open('spec/fixtures/example.csv') }

  it "can create an Importer" do
    expect(importer).to be_instance_of described_class
  end

  it "inherits from the Darlingtonia Importer" do
    expect(described_class).to be < Darlingtonia::Importer
  end

  it "creates three works from a three-row csv" do
    expect { importer.import }.to change { Etd.count }.by 3
    3.times do
      Etd.last.delete
    end
  end
end
