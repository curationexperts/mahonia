# frozen_string_literal: true
module Mahonia
  module MeshTermService
    # A service for returning data assocaited with MeSH terms
    # the service includes methods for returning MeSH IDs and
    # for getting MeSH terms from IDs. It also includes methods
    # for transforming arrays of MeSH URIs into labels and
    # vice versa. This is used in edit forms and show views
    # so that we are storing MeSH URIs in Fedora, but users see
    # them as MeSH labels/terms.
    URI_PREFIX = 'https://id.nlm.nih.gov/mesh/'
    ##
    # @return [String] the URI without the id
    def uri_prefix
      URI_PREFIX
    end

    ##
    # @param [String]
    # @return [String] the label for a MeSH term ID
    def label_from_id(id)
      m = Qa::Authorities::Mesh.new
      m.find(id)&.dig(:label)
    end

    ##
    # @param [String]
    # @return [String] the label for a complete MeSH term URI
    def label_from_uri(uri)
      id = uri.gsub(uri_prefix, '')
      m = Qa::Authorities::Mesh.new
      m.find(id)&.dig(:label)
    end

    ##
    # @param [String]
    # @return [String] The id for a MeSH label
    def id_from_label(label)
      m = Qa::Authorities::Mesh.new
      return "Subject: #{label}" if m.search(label.downcase) == []
      m.search(label.downcase).first[:id]
    end

    ##
    # @param [Array<String>]
    # @return [Array]  An array with URIs for MeSH terms, but plain strings for non-mesh terms
    def labels_to_uris(labels)
      labels.select { |label| !label.include?('Subject:') }
      labels.map { |label| id_from_label(label).include?('Subject:') ? label : RDF::URI.intern("#{uri_prefix}#{id_from_label(label)}") }
    end

    ##
    # @param [Array<String>]
    # @return [Array] An array of labels from MeSH uris
    def uris_to_labels(uris)
      uris.map { |uri| label_from_id(uri.gsub(uri_prefix, '')) }
    end

    ##
    # @param [ActiveFedora::Base]
    # @return [Array] An array of labels for the edit view
    def edit_subject_view(curation_concern)
      curation_concern[:subject] = curation_concern[:subject].map { |subject| subject.is_a?(String) ? subject : label_from_uri(subject_id_or_string(subject)) }
    end

    private

      ##
      # @param [String, RDF::URI]
      # @return [String] Return string for a subject, either itself as string or the id method
      def subject_id_or_string(subject)
        return subject.to_s if subject.try(:id).nil?
        subject.id
      end
  end
end
