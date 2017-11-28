# frozen_string_literal: true
class FakeDataciteConnection
  def initialize(*)
    @dois = {}
  end

  def create(metadata:)
    @dois[metadata.identifier] = metadata
  end

  def get(metadata:)
    map_record(@dois[metadata.identifier])
  end

  private

    ResponseRecord = Struct.new(:identifier, :titles)

    def map_record(record)
      ResponseRecord.new(record.identifier, record.try(:title))
    end
end
