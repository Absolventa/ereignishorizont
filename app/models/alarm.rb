class Alarm < ActiveRecord::Base
  ACTIONS = %w(email logger webhook)

  has_many :alarm_mappings, dependent: :destroy
  has_many :expected_events, through: :alarm_mappings

  validates :recipient_email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, on: :create },
                              presence: true,
                              if: ->(o) { o.kind.email? }

  validates :target, presence: { if: ->(o) { o.kind.webhook? } }

  validates_inclusion_of :action, in: ACTIONS

  before_validation :downcase_action

  def kind
    action.to_s.downcase.inquiry
  end

  def recipient_email=(value)
    self.target = value
  end

  def recipient_email
    target
  end

  def enters_email?
    ActiveSupport::Deprecation.warn 'use `Alarm#kind.email?`'
    kind.email?
  end

  def enters_logger?
    ActiveSupport::Deprecation.warn 'use `Alarm#kind.logger?`'
    kind.logger?
  end

  def run(expected_event)
    delivery_method = expected_event.persisted? ? :deliver_later : :deliver_now
    AlarmMailer.event_expectation_matched(self, expected_event).send(delivery_method) if enters_email?
    logger.info "THIS IS THE INFORMATION ABOUT YOUR EXPECTED EVENT ALARM" if kind.logger?
  end

  private

  def downcase_action
    self.action = action.to_s.downcase
  end
end
