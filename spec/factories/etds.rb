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
  end
end
