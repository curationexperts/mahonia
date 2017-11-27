# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Datacite::XmlBuilder do
  subject(:builder) { described_class.new }

  describe '::ATTRIBUTES' do
    it 'maps identifier' do
      expect(described_class::ATTRIBUTES).to include :identifier
    end

    it 'has an accessor for each attribute' do
      Datacite::XmlBuilder::ATTRIBUTES.each do |attr|
        expect { builder.public_send("#{attr}=", 'moomin') }
          .to change { builder.public_send(attr) }
          .to 'moomin'
      end
    end
  end

  describe '#build' do
    let(:identifier) { 'moomin' }

    before { builder.identifier = identifier }

    it do
      expect(builder.build).to include ">#{identifier}</identifier>"
    end
  end

  describe '#clear' do
    before { builder.identifier = 'moomin' }

    it 'empties attributes' do
      expect { builder.clear }
        .to change { builder.identifier }.to be_nil
    end
  end
end
