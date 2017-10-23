require 'rails_helper'

RSpec.describe CatalogController, type: :controller do
  describe 'facets' do
    let(:facets) do
      controller
        .blacklight_config
        .facet_fields.keys
        .map { |field| field.gsub(/\_s+im$/, '') }
    end

    let(:expected_facets) do
      ['human_readable_type',
       'resource_type',
       'creator',
       'contributor',
       'keyword',
       'subject',
       'language',
       'based_near_label',
       'publisher',
       'file_format',
       'member_of_collections',
       'generic_type']
    end

    it 'has exactly expected facets' do
      expect(facets).to contain_exactly(*expected_facets)
    end
  end
end
