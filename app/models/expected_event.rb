class ExpectedEvent < ActiveRecord::Base
  validates :title, presence: true, format: { with: IncomingEvent::FORMAT }
  validates :matching_direction, inclusion: { in: %w(backward forward) }
  validates_uniqueness_of :title

  has_many :alarm_mappings, dependent: :destroy
  has_many :alarms, through: :alarm_mappings
  has_many :alarm_notifications, dependent: :destroy
  has_many :incoming_events

  before_validation :delete_white_spaces_from_title

  validates_inclusion_of :final_hour, in: 1..24
  # TODO not needed for forward matching?

  scope :active,   -> do
    where(<<-EOFSQL, q: Time.zone.now)
    (started_at < :q AND ended_at > :q)
      OR (started_at < :q AND ended_at IS NULL)
      OR (started_at IS NULL AND ended_at IS NULL)
    EOFSQL
  end
  scope :forward,  -> { where(matching_direction: 'forward') }
  scope :backward, -> { where(matching_direction: 'backward') }
  scope :today,    -> { where("weekday_#{Date.today.wday}" => true) }

  def alarm!
    alarms.each { |alarm| alarm.run }
    AlarmNotification.create(expected_event: self)
  end

  def event_matching_direction
    if self.matching_direction == 'forward'
      "when found"
    else
      "when not found"
    end
  end

  def event_matching_direction_for_email
    if self.matching_direction == 'forward'
      "found"
    else
      "not found"
    end
  end

  def active?
    return false if started_at.nil? and ended_at
    return true if started_at.nil? and ended_at.nil?
    started_at < Time.zone.now and (ended_at.nil? || Time.zone.now <= ended_at.end_of_day)
  end

  def activity_status
    if active?
      "active"
    else
      "inactive"
    end
  end

  def checked_today?
    weekdays[Date.today.wday]
  end

  def deadline
    if checked_today?
      Time.zone.now.beginning_of_day + final_hour.hours
    else
      Time.zone.now.beginning_of_day
    end
  end

  def deadline_exceeded?
    return false if matching_direction == 'forward'
    Time.zone.now > deadline
  end

  def last_alarm_at
    last_alarm = alarm_notifications.order(:created_at).last
    last_alarm.created_at if last_alarm
  end

  def weekdays
    weekdays = []
    weekdays << !!self.weekday_0 #bang bang, converts nil values into booleans
    weekdays << !!self.weekday_1
    weekdays << !!self.weekday_2
    weekdays << !!self.weekday_3
    weekdays << !!self.weekday_4
    weekdays << !!self.weekday_5
    weekdays << !!self.weekday_6
    weekdays
  end

  private

  def delete_white_spaces_from_title
    self.title = self.title.strip if self.title
  end

end
