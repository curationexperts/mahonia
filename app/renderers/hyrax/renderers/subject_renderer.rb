# frozen_string_literal: true
module Hyrax
  module Renderers
    class SubjectRenderer < AttributeRenderer
      include Mahonia::MeshTermService

      def li_value(value)
        value = options[:value].first if value.is_a? Hash
        if value.include?('https://id.nlm.nih.gov/mesh')
          "#{link_to(label_from_uri(value), search_path(value))} <a target='_blank' href='#{value}'><span class='glyphicon glyphicon-new-window'></span></a>"
        else
          link_to(ERB::Util.h(value), search_path(value))
        end
      end

      private

        def search_path(value)
          Rails.application.routes.url_helpers.search_catalog_path(:"f[#{search_field}][]" => value)
        end

        def search_field
          ERB::Util.h(Solrizer.solr_name(options.fetch(:search_field, field), :facetable, type: :string))
        end
    end
  end
end
