FactoryGirl.define do

  factory :alarm do
    action 'email'
    sequence(:email_recipient) { |n| "johndoe#{n}@example.com"}
    title 'Title'

    trait :slack do
      action 'slack'
      email_recipient nil
      slack_url { "http://www.example.org/services/#{SecureRandom.hex(8)}" }
      slack_channel { '#event_grrl' }
      title 'Slack Alarm'
    end
  end

  factory :alarm_notification do
    expected_event
  end

  factory :expected_event do
    title 'my event title'
    final_hour { 1.hour.from_now.utc.hour }
    matching_direction 'forward'
    remote_side

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

  factory :remote_side do
    sequence(:name) { |n| "my remote side#{n}" }
  end
end
