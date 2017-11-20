module Mahonia
  module BlacklightHelper
    # Based on, but slightly different from helpers used in GeoBlacklight

    ##
    # Blacklight catalog controller helper method to truncate field value to 140 chars
    # From the helpers in GeoBlacklight
    # @param [SolrDocument] args
    # @return [String]
    def snippit(args)
      truncate(Array(args[:value]).flatten.join(' '), length: 140)
    end

    ##
    # Render value for a document's field as a truncate description
    # div. Arguments come from Blacklight::DocumentPresenter's
    # get_field_values method
    # @param [Hash] args from get_field_values
    def render_truncated_description(args)
      content_tag :div, class: 'truncate-description' do
        snippit(args) + link_to("View More", url_for(args[:document]), class: 'btn btn-default').to_s
      end
    end
  end
end
