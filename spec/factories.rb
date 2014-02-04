FactoryGirl.define do
  factory :user, aliases: [:author] do
    sequence(:first_name) { |n| "John #{n}" }
    sequence(:last_name) { |n| "Doe #{n}" }
    sequence(:email) { |n| "user#{n}@user.com" }
    password 123456
    password_confirmation 123456
    admin false
    student true
    
    factory :admin do
      admin true
    end
    
    factory :not_student do
      student false
    end
  end
  
  factory :about_us_entry do
    text "Hello World"
    author
    user
  end
  
  factory :profile_field do
    sequence(:name) { |n| "Name #{n}" }
    sequence(:description) { |n| "Field #{n}" }
  end
end