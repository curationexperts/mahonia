# frozen_string_literal: true
RSpec.shared_examples 'an IdentifierBuilder' do
  subject(:builder) { described_class.new }

  describe '#build' do
    it 'returns an identifier string' do
      expect(builder.build(hint: 'moomin'))
        .to respond_to :to_str
    end
  end
end
