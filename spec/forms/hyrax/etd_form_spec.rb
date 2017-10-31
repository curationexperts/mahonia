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

  describe '#terms' do
    it { expect(form.terms).to include :date_label }
    it { expect(form.terms).to include :degree }
    it { expect(form.terms).to include :institution }
    it { expect(form.terms).to include :orcid_id }
    it { expect(form.terms).to include :resource_type }
    it { expect(form.terms).to include :rights_note }
  end
end
