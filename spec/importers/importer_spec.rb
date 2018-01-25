# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Importer do
  subject(:importer) { described_class.new(parser: parser) }
  let(:file) { File.open('spec/fixtures/example.csv') }
  let(:parser) { MahoniaCsvParser.new(file: file) }

  it "can create an Importer" do
    expect(importer).to be_instance_of described_class
  end

  it "inherits from the Darlingtonia Importer" do
    expect(described_class).to be < Darlingtonia::Importer
  end

  it "uses the MahoniaCsvParser" do
    expect(importer.parser.class).to eq MahoniaCsvParser
  end

  it "creates three works from a three-row csv", :clean do
    expect { importer.import }.to change { Etd.count }.by 3
  end

  it "creates an Etd with the correct metadata", :clean do
    importer.import

    expect(Etd.where(title: "Unicode Description").count).to eq 1
  end

  describe '.config' do
    it 'has configuration attributes' do
      expect(described_class.config).to include('username'  => an_instance_of(String),
                                                'password'  => an_instance_of(String),
                                                'file_path' => an_instance_of(String))
    end
  end

  describe '#config' do
    it 'has configuration attributes' do
      expect(importer.config).to include('username'  => an_instance_of(String),
                                         'password'  => an_instance_of(String),
                                         'file_path' => an_instance_of(String))
    end
  end

  context "With a BePress exported csv", :clean do
    description = <<-HERE
 A far ultraviolet (UV) spectroscopic ellipsometer  system working up to 9 eV has been   developed and applied to characterize high-K- dielectric materials. These materials have   been gaining greater attention as possible  substitutes for Si02 as gate dielectrics in   aggressively scaled silicon devices. The optical  properties of representative high-K bulk   crystalline, epitaxial, and amorphous films, were investigated with far UV spectroscopic   ellipsometry and some by visible-near UV  optical transmission measurements. Optical   dielectric functions and optical band gap  energies for these materials are obtained from   these studies. The spectroscopic data and  results provide information that is needed to   select viable alternative dielectric candidate  materials with adequate band gaps, and   conduction and valence band offset energies for this application, and additionally to   provide an optical metrology for gate dielectric  films on silicon substrates. For   materials with anisotropic structure such as  single crystal DySC03and GdSc03 an   analysis process was developed to determine  the optical constant tensor.
    HERE
    let(:file) { File.open('spec/fixtures/bepress_etd_sample.csv') }
    let(:record_attributes) do
      { institution: ["Oregon Health & Science University"],
        school: ["OGI School of Science and Engineering"],
        description: [description],
        keyword: ["Ellipsometry, Dielectrics -- Optical properties, Ellipsometry; high-K dielectrics; Bandgaps"],
        identifier: ["doi:10.6083/M4QN64NB"],
        department: ["Dept. of Computer Science and Electrical Engineering"],
        title: ["Dielectric functions and optical bandgaps of high-K dielectrics by far ultraviolet spectroscopic ellipsometry"] }
    end

    it "can import and create Etds", :clean do
      expect { importer.import }.to change { Etd.count }.by 3
    end

    it "successfully maps the BePress data to a new Etd's metadata", :clean do
      importer.import
      expect(Etd.where(title: record_attributes[:title]).first).to have_attributes(record_attributes)
    end

    it 'attaches the representative file', :perform_enqueued do
      ActiveJob::Base.queue_adapter.filter = [AttachFilesToWorkJob, IngestJob]

      importer.import
      created_etd = Etd.where(title: record_attributes[:title]).first

      expect(created_etd.representative)
        .to have_attributes(title: contain_exactly('200603.cicerrella.elizabeth.pdf'))
    end
  end
end
