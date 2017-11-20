class FakeIdentifierBuilder
  attr_accessor :ids

  def initialize(*ids)
    @ids = ids
    @ids = ['OneFreeId'] if @ids.empty?
  end

  def build(*)
    @enum_ids ||= ids.to_enum
    @enum_ids.next
  end
end

# rubocop:disable RSpec/FilePath
RSpec.describe FakeIdentifierBuilder do
  it_behaves_like 'an IdentifierBuilder'

  describe '#build' do
    it 'returns the given ids in order'
  end
end
# rubocop:enable RSpec/FilePath
