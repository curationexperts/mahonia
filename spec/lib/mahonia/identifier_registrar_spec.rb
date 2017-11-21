require 'rails_helper'

RSpec.describe Mahonia::IdentifierRegistrar do
  subject(:registrar) { described_class.new(builder: :NOT_A_REAL_BUILDER) }

  it_behaves_like 'an IdentifierRegistrar'

  it 'is abstract' do
    expect { registrar.register!(object: :NOT_A_REAL_OBJECT) }
      .to raise_error NotImplementedError
  end
end
