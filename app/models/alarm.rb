class Alarm < ActiveRecord::Base
  validates :nature, :expected_event, presence: true
  belongs_to :expected_event
end