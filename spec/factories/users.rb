FactoryBot.define do
  factory :user do
    name {|n| "test_user" }
    email {|n| "user_#{n}@test.com" }
    password {'password' }
    password_confirmation {'password' }    
  end
end
