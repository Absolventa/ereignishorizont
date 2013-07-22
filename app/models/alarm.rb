class Alarm < ActiveRecord::Base
  validates :nature, :expected_event, presence: true
  belongs_to :expected_event

  def run
  	#self.pidgeon = 'Fly fly away'
  	# send pidgeon, sms,…
  end


end