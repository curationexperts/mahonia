# frozen_string_literal: true
require 'rails_helper'

RSpec.describe MahoniaMapper do
  subject(:mapper) { described_class.new }

  description = <<-HERE
A far ultraviolet (UV) spectroscopic ellipsometer  system working up to 9 eV has been   developed and applied to characterize high-K- dielectric materials. These materials have   been gaining greater attention as possible  substitutes for Si02 as gate dielectrics in   aggressively scaled silicon devices. The optical  properties of representative high-K bulk   crystalline, epitaxial, and amorphous films, were investigated with far UV spectroscopic   ellipsometry and some by visible-near UV  optical transmission measurements. Optical   dielectric functions and optical band gap  energies for these materials are obtained from   these studies. The spectroscopic data and  results provide information that is needed to   select viable alternative dielectric candidate  materials with adequate band gaps, and   conduction and valence band offset energies for this application, and additionally to   provide an optical metrology for gate dielectric  films on silicon substrates. For   materials with anisotropic structure such as  single crystal DySC03and GdSc03 an   analysis process was developed to determine  the optical constant tensor.
  HERE
  let(:hyrax_metadata) do
    { institution: ["Oregon Health & Science University"],
      school: ["OGI School of Science and Engineering"],
      description: [description],
      keyword: ["Ellipsometry, Dielectrics -- Optical properties, Ellipsometry; high-K dielectrics; Bandgaps"],
      identifier: ["doi:10.6083/M4QN64NB"],
      license: ["Creative Commons"],
      department: ["Dept. of Computer Science and Electrical Engineering"],
      title: ["Dielectric functions and optical bandgaps of high-K dielectrics by far ultraviolet spectroscopic ellipsometry"],
      creator: ["Marie Curie"] }
  end

  it "maps the required title field" do
    mapper.metadata = { "title" => "Research" }
    expect(mapper.map_field(:title)).to eq(["Research"])
  end

  context "Hyrax Etds" do
    let(:input_record) { Darlingtonia::InputRecord.from(metadata: bepress_metadata, mapper: described_class.new) }
    let(:bepress_metadata) do
      { "institution_name" => "Oregon Health & Science University",
        "school" => "OGI School of Science and Engineering",
        "abstract" => description,
        "keywords" => "Ellipsometry, Dielectrics -- Optical properties, Ellipsometry; high-K dielectrics; Bandgaps",
        "identifier" => "doi:10.6083/M4QN64NB",
        "department" => "Dept. of Computer Science and Electrical Engineering",
        "distribution_license" => "Creative Commons",
        "title" => "Dielectric functions and optical bandgaps of high-K dielectrics by far ultraviolet spectroscopic ellipsometry",
        "author1_fname" => "Marie",
        "author1_lname" => "Curie" }
    end

    it "provides all the necessary fields" do
      mapper.metadata = bepress_metadata

      expect(input_record.attributes.eql?(hyrax_metadata)).to be_truthy
    end

    it 'maps publisher to "OHSU Scholar Archive"' do
      mapper.metadata = { "title" => "War and Peace" }

      expect(mapper.publisher).to contain_exactly "OHSU Scholar Archive"
    end

    describe '#representative_file' do
      it 'maps from file_name' do
        mapper.metadata = { "file_name" => "research.pdf" }
        expect(mapper.representative_file).to eq 'research.pdf'
      end
    end
  end

  context "handles multi-value fields" do
    let(:input_record) { Darlingtonia::InputRecord.from(metadata: bepress_metadata, mapper: described_class.new) }

    let(:ten_creators) do
      ["Marie Curie", "Albert Einstein", "Richard Feynman", "Hedy Lamarr", "Nina Byers", "Gabriela Gonzales", "Deborah Jin", "Lise Meitner", "Ursula LeGuin", "Rebecca Solnit"]
    end

    let(:authors) do
      { "author1_fname" => "Marie",
        "author1_lname" => "Curie",
        "author2_fname" => "Albert",
        "author2_lname" => "Einstein",
        "author3_fname" => "Richard",
        "author3_lname" => "Feynman",
        "author4_fname" => "Hedy",
        "author4_lname" => "Lamarr",
        "author5_fname" => "Nina",
        "author5_lname" => "Byers",
        "author6_fname" => "Gabriela",
        "author6_lname" => "Gonzales",
        "author7_fname" => "Deborah",
        "author7_lname" => "Jin",
        "author8_fname" => "Lise",
        "author8_lname" => "Meitner",
        "author9_fname" => "Ursula",
        "author9_lname" => "LeGuin",
        "author10_fname" => "Rebecca",
        "author10_lname" => "Solnit" }
    end

    it "returns all values for multi-valued fields" do
      mapper.metadata = { "title1" => "One", "title2" => "Two", "title3" => "Three" }

      expect(mapper.map_field(:title)).to eq(["One", "Two", "Three"])
    end

    it "returns a value for multi-valued fields with one value" do
      mapper.metadata = { "title1" => "One" }

      expect(mapper.map_field(:title)).to eq(["One"])
    end

    it "provides a creator field that returns first and last author name" do
      mapper.metadata = { "author1_fname" => "Marie", "author1_lname" => "Curie" }

      expect(mapper.creator).to eq(["Marie Curie"])
    end

    it "won't map creator if first and last name are both nil" do
      mapper.metadata = { "author1_fname" => nil, "author1_lname" => nil }

      expect(mapper.creator.nil?).to be_truthy
    end

    it "will map creator with first name if last name is nil" do
      mapper.metadata = { "author1_fname" => "Marie", "author1_lname" => nil }

      expect(mapper.creator).to eq(["Marie"])
    end

    it "will map creator with last name if first name is nil" do
      mapper.metadata = { "author1_fname" => nil, "author1_lname" => "Curie" }

      expect(mapper.creator).to eq(["Curie"])
    end

    it "provides 10 creators from 10 author first and last name pairs" do
      mapper.metadata = authors

      expect(mapper.creator).to match_array(ten_creators)
    end
  end
end
