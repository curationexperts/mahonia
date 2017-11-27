# frozen_string_literal: true
FactoryBot.define do
  factory :user do
    sequence :email do |n|
      "test_user_#{n}@example.com"
    end
    password 'password'
    display_name FFaker::Name.name

    factory :admin do
      roles { [Role.where(name: 'admin').first_or_create] }
    end
  end
end
