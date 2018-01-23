# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Mahonia::EdtfLiteral do
  subject(:literal) { described_class.new(edtf_str) }
  let(:edtf_str)    { '199x' }

  it 'has an EDTF datatype' do
    expect(literal)
      .to have_attributes(datatype: RDF::URI('http://id.loc.gov/datatypes/edtf/EDTF'))
  end
end
