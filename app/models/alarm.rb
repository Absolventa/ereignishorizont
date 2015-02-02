class Alarm < ActiveRecord::Base
  ACTIONS = %w(email logger webhook)

  has_many :alarm_mappings, dependent: :destroy
  has_many :expected_events, through: :alarm_mappings

  validates :email_recipient, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, on: :create },
                              presence: true,
                              if: ->(o) { o.kind.email? }

  validates :webhook_url, presence: { if: ->(o) { o.kind.webhook? } }

  validates_inclusion_of :action, in: ACTIONS

  before_validation :downcase_action

  def kind
    action.to_s.downcase.inquiry
  end

  def run(expected_event)
    delivery_method = expected_event.persisted? ? :deliver_later : :deliver_now
    AlarmMailer.event_expectation_matched(self, expected_event).send(delivery_method) if kind.email?
    logger.info "THIS IS THE INFORMATION ABOUT YOUR EXPECTED EVENT ALARM" if kind.logger?
  end

  private

  def downcase_action
    self.action = action.to_s.downcase
  end
end
