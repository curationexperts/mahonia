# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Hyrax::Renderers::SubjectRenderer, mesh: true do
  let(:field) { :subject }
  let(:renderer) { described_class.new(field, ['https://id.nlm.nih.gov/mesh/D013416']) }
  let(:markup) { subject }
  before do
    import_mesh_terms
  end

  describe "#attribute_to_html" do
    subject { Nokogiri::HTML(renderer.render) }

    let(:expected) { Nokogiri::HTML(tr_value) }

    let(:tr_value) do
      # rubocop:disable Metrics/LineLength
      "<tr><th>Subject</th>\n<td><ul class='tabular'><li itemprop=\"about\" itemscope itemtype=\"http://schema.org/Thing\" class=\"attribute subject\"><span itemprop=\"name\"><a href=\"/catalog?f%5Bsubject_sim%5D%5B%5D=https%3A%2F%2Fid.nlm.nih.gov%2Fmesh%2FD013416\">Sulfamerazine</a> <a target='_blank' href='https://id.nlm.nih.gov/mesh/D013416'><span class='glyphicon glyphicon-new-window'></span></a></span></li></ul></td></tr>"
    end

    it { expect(markup).to be_equivalent_to(expected) }
  end
end
