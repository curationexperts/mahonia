# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Qa do
  describe '.table_name_prefix' do
    it { expect(described_class.table_name_prefix).to end_with '_' }
  end
end
