class AlarmMapping < ApplicationRecord

  belongs_to :alarm
  belongs_to :expected_event

end
