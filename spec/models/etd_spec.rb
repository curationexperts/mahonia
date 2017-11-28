# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Etd do
  subject(:etd) { FactoryGirl.build(:etd) }

  it_behaves_like 'a model with hyrax basic metadata', except: :keyword
  it_behaves_like 'a model with ohsu core metadata'
  it_behaves_like 'a model with ohsu ETD metadata'

  describe 'an attached pdf' do
    let(:actor)  { Hyrax::Actors::FileSetActor.new(FileSet.create, user) }
    let(:upload) { FactoryGirl.build(:pdf_upload) }
    let(:user)   { FactoryGirl.build(:user) }

    before do
      actor.create_metadata({})
      actor.create_content(upload)
      actor.attach_to_work(etd)
    end

    it 'is the representative file' do
      expect(etd.representative).to eq actor.file_set
    end

    it 'is the thumbnail' do
      expect(etd.thumbnail).to eq actor.file_set
    end
  end

  describe '.application_url' do
    let(:id) { 'moomin_id' }

    it 'returns a url' do
      expect(described_class.application_url(id: id)).to end_with id
    end
  end

  describe '#application_url' do
    context 'with no id set' do
      it 'raises an ArgumentError' do
        expect { etd.application_url }.to raise_error ArgumentError
      end
    end

    context 'with an id' do
      subject(:etd) { FactoryGirl.build(:etd, id: id) }
      let(:id)      { 'moomin_id' }

      it 'returns a url' do
        expect(etd.application_url).to end_with id
      end
    end
  end

  describe '#date_uploaded' do
    let(:time) { DateTime.current }

    it 'is a DateTime' do
      expect { etd.date_uploaded = time }
        .to change { etd.date_uploaded }
        .to be_a DateTime
    end

    context 'when created through a work actor' do
      subject(:etd) { FactoryBot.actor_create(:etd) }

      before { allow(Hyrax::TimeService).to receive(:time_in_utc) { time } }

      it 'is set by actor stack' do
        expect(etd.date_uploaded).to eq time
      end
    end
  end

  describe '#title' do
    it 'validates presence' do
      etd = FactoryGirl.build(:etd, title: [])
      expect { etd.valid? }
        .to change { etd.errors.details }
        .to include(title: [{ error: :blank }])
    end
  end
end
