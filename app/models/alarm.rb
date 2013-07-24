class Alarm < ActiveRecord::Base
  validates :nature, :expected_event, presence: true
  belongs_to :expected_event

  def run
    ## Do stuff based on my nature
    # if nature == 'email'
    #   AlarmMail.my_alarm_method(self).deliver
    # ...
  end


end