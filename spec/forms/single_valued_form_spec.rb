# frozen_string_literal: true
require 'rails_helper'

RSpec.describe SingleValuedForm do
  subject(:etd) { TestForm.new(work, nil, nil) }
  let(:work) { FactoryBot.build :etd }

  before do
    class TestForm < Hyrax::Forms::WorkForm
      include SingleValuedForm
    end
    TestForm.single_valued_fields = [:degree]
    TestForm.model_class = ::Etd
    TestForm.terms = [:degree, :title]
  end

  after do
    Object.send(:remove_const, :TestForm)
  end

  context "an instance" do
    it "reports multiple-valued fields" do
      expect(etd.multiple?(:title)).to be true
    end
    it "reports single-valued fields" do
      expect(etd.multiple?(:degree)).to be false
    end
  end

  context "the class" do
    it "reports multiple-valued fields" do
      expect(TestForm.multiple?(:title)).to be true
    end
    it "reports single-valued fields" do
      expect(TestForm.multiple?(:degree)).to be false
    end
  end

  describe "model_attributes" do
    let(:params) { ActionController::Parameters.new(degree: 'D.N.P.') }
    let(:attribs) { TestForm.model_attributes(params).to_h }

    it "converts singular fields to arrays" do
      expect(attribs[:degree]).to eq(['D.N.P.'])
    end
  end
end
