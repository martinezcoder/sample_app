FactoryGirl.define do

  factory :user0 do
    name "Fran J Martinez"
    email "fran.martinez@socialwin.es"
    password "foobar"
    password_confirmation "foobar"
  end

  factory :user do
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}   
    password "foobar"
    password_confirmation "foobar"

    factory :admin do
      admin true
    end
  end

  factory :micropost do
    content "Lorem ipsum"
    user
  end
end

