class Alarm < ActiveRecord::Base
  validates :nature, :expected_event, presence: true
  belongs_to :expected_event

  def run
  	# send pidgeon, sms,…
  end
end