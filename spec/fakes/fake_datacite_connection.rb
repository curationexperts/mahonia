# frozen_string_literal: true
##
# A fake connection to DataCite.
#
# `#dois` and `#registered` are offered as spies.
class FakeDataciteConnection
  attr_reader :dois, :registered

  def initialize(*)
    @dois       = {}
    @registered = {}
  end

  def create(metadata:)
    @dois[metadata.identifier] = metadata
  end

  def get(metadata:)
    map_record(@dois[metadata.identifier])
  end

  def register(metadata:, url:)
    @registered[metadata.identifier] = url
  end

  private

    ResponseRecord = Struct.new(:identifier, :titles)

    def map_record(record)
      ResponseRecord.new(record.identifier, record.try(:title))
    end
end
