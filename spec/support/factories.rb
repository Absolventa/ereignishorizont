FactoryGirl.define do

  factory :expected_event do
  	title 'my event title'
    final_hour 15
  end

  factory :incoming_event do
  	title 'my event title'
  end

  factory :user do
  	sequence(:email) { |n| "johndoe#{n}@example.com"}
  	password 'foobarbaz'
  	password_confirmation { password }
  end

end
