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

  describe '#date_uploaded' do
    subject(:etd) { FactoryBot.actor_create(:etd) }
    let(:xmas)    { DateTime.parse('2017-12-25 11:30').iso8601 }

    before { allow(Hyrax::TimeService).to receive(:time_in_utc) { xmas } }

    it 'is set by actor stack' do
      expect(etd.date_uploaded).to eq xmas
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
