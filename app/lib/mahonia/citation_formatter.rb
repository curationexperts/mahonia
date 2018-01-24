# frozen_string_literal: true
module Mahonia
  ##
  #
  class CitationFormatter
    ##
    # @!attribute [rw] object
    #   @return [Object]
    attr_accessor :object

    ##
    # @param object [Object] the object to bulid citations for.
    def initialize(object:)
      @object = object
    end

    class << self
      ##
      # @param opts [Hash]
      # @option opts [Object] :object the object to bulid citations for.
      #
      # @return [String] a citation for the object
      def citation_for(**opts)
        new(**opts).citation
      end
    end

    ##
    # @note this method returns an `html_safe` string
    #   (`ActiveSupport::SafeBuffer`). It is sanitized to allow only <i>, <b>,
    #   and <br> tags.
    #
    # @return [ActiveSupport::SafeBuffer] an html safe citation for the object
    def citation
      cite = CiteProc::Processor
             .new(style: 'ohsu-apa', format: 'html')
             .import(item)
             .render(:bibliography, id: :item)
             .first
      sanitize(citation: cite)
    rescue CiteProc::Error, TypeError, ArgumentError => e
      Rails.logger.warn("Failed to generate citation with CiteProc; falling " \
                        "back on a hard coded citation\n\t#{e.message}")
      cite = "#{object.creator.join(', ')}. #{object.title.first} " \
             "(#{(object.date || []).first}). <i>OHSU Scholar Archive</i>. " \
             "#{object.id}.#{' ' + doi if doi}\n#{url}"
      sanitize(citation: cite)
    end

    def item
      CiteProc::Item.new(id:               :item,
                         type:             'thesis',
                         title:             object.title.first,
                         identifier:        object.id,
                         author:            object.creator,
                         issued:            object.date,
                         'container-title': 'OHSU Scholar Archive',
                         DOI:               doi,
                         internal_url:      url)
    end

    def doi
      object.identifier.first
    end

    def url
      return unless (id = object.id)
      Etd.application_url(id: id)
    end

    private

      # rubocop:disable Rails/OutputSafety
      def sanitize(citation:)
        Rails::Html::WhiteListSanitizer
          .new.sanitize(citation, tags: %w[i b br]).html_safe
      end # rubocop:enable Rails/OutputSafety
  end
end
