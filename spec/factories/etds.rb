FactoryGirl.define do
  factory :etd do
    transient do
      user { FactoryGirl.create(:user) }
      pdf  { nil }
    end

    # give the user edit access
    after(:build) do |work, evaluator|
      work.apply_depositor_metadata(evaluator.user.user_key)

      if evaluator.pdf
        actor = Hyrax::Actors::FileSetActor.new(FileSet.create, evaluator.user)
        actor.create_metadata({})
        actor.create_content(evaluator.pdf)
        actor.attach_to_work(work)
      end
    end

    title ['Comet in Moominland']

    factory :public_etd do
      visibility Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
    end

    factory :moomins_thesis do
      creator       ['Moomin', 'Hemulen']
      date_label    ['Winter in Moomin Valley']
      degree        ['M.Phil.']
      identifier    ['Moomin_123']
      institution   ['Moomin Valley Community College']
      keyword       ['moomin', 'snork', 'hattifattener']
      language      ['Finnish', 'Swedish']
      orcid_id      ['0000-0001-2345-6789', '0000-0002-1825-0097']
      source        ['Too-Ticky', 'Snufkin']
      subject       ['Moomins', 'Snorks']
      rights_note   ['For the exclusive viewing of Little My.',
                     'Moomin: do not read this.']
      resource_type ['thesis']
    end
  end
end
