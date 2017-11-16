require 'rails_helper'

RSpec.describe Mahonia::DataciteDoiBuilder do
  subject(:builder) { described_class.new }

  it_behaves_like 'an IdentifierBuilder'

  describe '#build' do
    it 'generates unique ids with cirneco'
  end
end
