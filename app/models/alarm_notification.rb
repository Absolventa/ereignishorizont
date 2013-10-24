class AlarmNotification < ActiveRecord::Base
  belongs_to :expected_event, inverse_of: :alarm_notifications
  belongs_to :remote_side,    inverse_of: :alarm_notifications

  validates :expected_event, presence: true
  validate  :expected_event_must_be_unique_for_today

  scope :today, -> { where('created_at > ?', Time.zone.now.beginning_of_day) }

  private

  def expected_event_must_be_unique_for_today
    unless AlarmNotification.where(expected_event_id: self.expected_event_id).
      today.empty?
      errors.add(:expected_event_id, 'has already been registered for today' )
    end
  end
end
