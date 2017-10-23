require 'rails_helper'

RSpec.describe Etd do
  subject(:etd) { FactoryGirl.create(:etd) }

  it_behaves_like 'a model with basic metadata'

  describe 'an attached pdf' do
    let(:actor)  { Hyrax::Actors::FileSetActor.new(FileSet.create, user) }
    let(:upload) { FactoryGirl.create(:pdf_upload) }
    let(:user)   { FactoryGirl.create(:user) }

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
      expect { FactoryGirl.create(:etd, title: []) }
        .to raise_error ActiveFedora::RecordInvalid
    end
  end
end
