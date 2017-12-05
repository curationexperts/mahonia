# frozen_string_literal: true
require 'rails_helper'

RSpec.describe OkComputer::DataciteConnectionCheck do
  subject(:check) { described_class.new }

  describe '#check' do
    context 'in a failing state' do
      # this counts on a fake datacite password in the .env available to the test
      # suite
      it 'marks failure occurred' do
        expect { check.check }
          .to change { check.failure_occurred }
          .to(true)
      end
    end

    context 'with a good connection' do
      let(:connection) { FakeDataciteConnection.new }

      before { check.connection = connection }

      it 'marks success' do
        expect { check.check }.not_to change { check.success? }.from(true)
      end
    end
  end
end
