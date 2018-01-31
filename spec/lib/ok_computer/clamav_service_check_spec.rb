# frozen_string_literal: true
require 'rails_helper'

RSpec.describe OkComputer::ClamavServiceCheck do
  subject(:check) { described_class.new }

  describe '#check' do
    context 'in a failing state' do
      it 'marks failure occurred' do
        expect { check.check }
          .to change { check.failure_occurred }
          .to(true)
      end
    end

    context 'with a working Clamby interface', :virus_scan do
      it 'marks success' do
        expect { check.check }.not_to change { check.success? }.from(true)
      end
    end
  end
end
