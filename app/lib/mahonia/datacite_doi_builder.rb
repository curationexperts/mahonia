module Mahonia
  ##
  # An identifier builder that builds DataCite DOIs in the way recommended by
  #  the DataCite Metadata Store (MDS) API documentation.
  #
  # @see https://support.datacite.org/docs/mds-2
  class DataciteDoiBuilder < IdentifierBuilder
    ##
    # @note hints are ignored
    #
    # @see IdentifierBuilder#build
    def build(*)
      '10.5555/1234'
    end
  end
end
