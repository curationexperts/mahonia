# Generated via
#  `rails generate hyrax:work Etd`
require 'rails_helper'

RSpec.describe Hyrax::EtdForm do
  subject(:form) { described_class.new(pdf, nil, nil) }
  let(:pdf)      { FactoryGirl.build(:etd) }

  describe '#required_fields' do
    it 'requires title' do
      expect(form.required_fields).to include :title
    end
  end
end
