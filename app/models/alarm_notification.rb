class AlarmNotification < ActiveRecord::Base
  belongs_to :expected_event

  validates :expected_event, presence: true
  validate  :expected_event_must_be_unique_for_today

  private

  def expected_event_must_be_unique_for_today
    unless AlarmNotification.where(expected_event_id: self.expected_event_id).
      where('created_at > ?', Time.zone.now.beginning_of_day).empty?
      errors.add(:expected_event_id, 'has already been registered for today' )
    end
  end
end
