class AlarmMapping < ActiveRecord::Base

  belongs_to :alarm
  belongs_to :expected_event

end