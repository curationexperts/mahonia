class FakeDataciteConnection
  def initialize(*)
    @dois = {}
  end

  def create(metadata:)
    @dois[metadata.identifier] = metadata
  end
end
