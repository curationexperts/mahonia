FactoryGirl.define do
  factory :user do
    sequence :email do |n|
      "test_user_#{n}@example.com"
    end

    password 'password'
  end
end
