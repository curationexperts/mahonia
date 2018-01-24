# frozen_string_literal: true
class Etd < ActiveFedora::Base
  include ::Hyrax::WorkBehavior

  self.indexer = EtdIndexer
  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []
  validates :title, presence: { message: 'Your work must have a title.' }

  self.human_readable_type = 'Etd'

  # This must be included at the end, because it finalizes the metadata
  # schema (by adding accepts_nested_attributes)
  include ::Hyrax::BasicMetadata

  apply_schema Schemas::CoreMetadata, Schemas::GeneratedResourceSchemaStrategy.new
  apply_schema Schemas::EtdMetadata,  Schemas::GeneratedResourceSchemaStrategy.new

  ##
  # @param id [String]
  #
  # @return [String] the url for an etd with the current id
  def self.application_url(id:)
    Rails.application.routes.url_helpers.hyrax_etd_url(id)
  end

  ##
  # @param id [String]
  #
  # @return [String]
  # @raise [ArgumentError] if the object does not have an id
  def application_url
    raise ArgumentError, "Tried to build a URL for new record #{self}" unless id
    self.class.application_url(id: id)
  end
end
