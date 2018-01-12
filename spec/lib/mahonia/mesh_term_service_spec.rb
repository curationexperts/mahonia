# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Mahonia::MeshTermService, mesh: true do
  subject(:mesh_term) { (Class.new { include Mahonia::MeshTermService }).new }
  let(:label) { 'Sulfamerazine' }
  let(:labels) { ['Sulfamerazine'] }
  let(:id) { 'D013416' }
  let(:uri) { 'https://id.nlm.nih.gov/mesh/D013416' }
  let(:uris) { ['https://id.nlm.nih.gov/mesh/D013416'] }
  let(:uri_prefix) { 'https://id.nlm.nih.gov/mesh/' }
  let(:non_mesh_term) { 'Sumerian Grammar' }
  let(:non_mesh_prefixed_term) { 'Subject: Sumerian Grammar' }
  let(:mixed_labels) { ['Subject: Sumerian Grammar', 'Sulfamerazine'] }
  let(:mixed_uris) { ['Subject: Sumerian Grammar', 'https://id.nlm.nih.gov/mesh/D013416'] }
  let(:subject_uris) { { subject: [RDF::URI('https://id.nlm.nih.gov/mesh/D013416')] } }

  before do
    import_mesh_terms
  end

  describe '#uri_prefix' do
    it 'returns the MeSH uri prefix' do
      expect(mesh_term.uri_prefix).to eq(uri_prefix)
    end
  end

  describe '#label_from_id' do
    it 'returns a MeSH term as a label when given an ID' do
      expect(mesh_term.label_from_id(id)).to eq(label)
    end
  end

  describe '#label_from_uri' do
    it 'returns a MeSH term as a label when given a URI' do
      expect(mesh_term.label_from_uri(uri)).to eq(label)
    end
  end

  describe '#id_from_label' do
    it 'returns a MeSH id when given a label' do
      expect(mesh_term.id_from_label(label)).to eq(id)
    end

    it 'returns a prefixed string when given a subject that is not a MeSH term' do
      expect(mesh_term.id_from_label(non_mesh_term)).to eq(non_mesh_prefixed_term)
    end
  end

  describe '#labels_to_uris' do
    it 'returns an array of uris when given an array of labels' do
      expect(mesh_term.labels_to_uris(labels)).to eq(uris)
    end

    it 'returns an array of uris and strings when given a mix of MeSH and non-MeSH terms' do
      expect(mesh_term.labels_to_uris(mixed_labels)).to eq(mixed_uris)
    end
  end

  describe '#uris_to_labels' do
    it 'returns an array of uris when given an array of labels' do
      expect(mesh_term.uris_to_labels(uris)).to eq(labels)
    end
  end

  describe '#uris_to_labels' do
    it 'returns an array of labels when given a hash with a subject param with uris' do
      expect(mesh_term.edit_subject_view(subject_uris)).to eq(labels)
    end
  end
end
