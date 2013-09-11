FactoryGirl.define do

  factory :alarm do
    action 'Email'
  	sequence(:recipient_email) { |n| "johndoe#{n}@example.com"}
    expected_event
  end

  factory :expected_event do
  	title 'my event title'
    final_hour 15
    matching_direction true

    factory :active_expected_event do
      started_at 2.days.ago
      ended_at 2.days.from_now
    end
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
