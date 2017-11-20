module Mahonia
  ##
  # An identifier builder that builds DataCite DOIs in the way recommended by
  #  the DataCite Metadata Store (MDS) API documentation.
  #
  # @see https://support.datacite.org/docs/mds-2
  class DataciteDoiBuilder < IdentifierBuilder
    ##
    # @see IdentifierBuilder#initialize
    def initialize(prefix: Datacite::Configuration.instance.prefix)
      super
    end

    ##
    # @note hints are ignored
    #
    # @see IdentifierBuilder#build
    def build(*)
      prefix + '/1234'
    end
  end
end
