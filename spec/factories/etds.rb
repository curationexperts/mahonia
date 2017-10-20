FactoryGirl.define do
  factory :etd do
    transient do
      user { FactoryGirl.create(:user) }
    end

    # give the user edit access
    after(:build) do |work, evaluator|
      work.apply_depositor_metadata(evaluator.user.user_key)
    end

    title ['Comet in Moominland']

    factory :public_etd do
      visibility Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
    end
  end
end
