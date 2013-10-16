class Alarm < ActiveRecord::Base
  ACTIONS = ["Email", "Logger"]

  has_many :alarm_mappings, dependent: :destroy
  has_many :expected_events, through: :alarm_mappings

  validates :recipient_email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, on: :create },
                              presence: true,
                              if: :enters_email?

  validates_inclusion_of :action, in: ACTIONS

  def enters_email?
    action == 'Email'
  end

  def enters_logger?
    action == 'Logger'
  end

  def run expected_event
    AlarmMailer.event_expectation_matched(self, expected_event).deliver if enters_email?
    logger.info "THIS IS THE INFORMATION ABOUT YOUR EXPECTED EVENT ALARM" if enters_logger?
  end
end
