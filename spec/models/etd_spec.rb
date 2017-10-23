require 'rails_helper'

RSpec.describe Etd do
  subject(:etd) { FactoryGirl.build(:etd) }

  it_behaves_like 'a model with basic metadata'

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

  describe '#title' do
    it 'validates presence' do
      etd = FactoryGirl.build(:etd, title: [])
      expect { etd.valid? }
        .to change { etd.errors.details }
        .to include(title: [{ error: :blank }])
    end
  end
end
