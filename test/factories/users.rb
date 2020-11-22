FactoryBot.define do
  factory :user do
    trait :default do
      first_name { 'Bob' }
      last_name { 'Vance' }
      email { 'bob@vance.com' }
      password { 'Ta123456' }
    end
  end
end