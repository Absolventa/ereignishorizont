class ExpectedEvent < ActiveRecord::Base
  validates :title, presence: true, format: { with: IncomingEvent::FORMAT }
  validates :matching_direction, inclusion: { in: [true, false] }
  validates_uniqueness_of :title

  has_many :alarms, dependent: :destroy
  has_many :alarm_notifications, dependent: :destroy
  has_many :incoming_events

  before_validation :delete_white_spaces_from_title

  validates_inclusion_of :final_hour, in: 1..24
  # TODO not needed for forward matching?

  scope :active,   -> { where("started_at < :q AND ended_at > :q", q: Time.zone.now)}
  scope :forward,  -> { where(matching_direction: true) }
  scope :backward, -> { where(matching_direction: false) }
  scope :today,    -> { where("weekday_#{Date.today.wday}" => true) }

  def alarm!
    alarms.each { |alarm| alarm.run }
    AlarmNotification.create(expected_event: self)
  end

  def event_matching_direction
    if self.matching_direction
      "when found"
    else
      "when not found"
    end
  end

  def event_matching_direction_for_email
    if self.matching_direction
      "found"
    else
      "not found"
    end
  end

  def active?
    return false unless self.started_at and self.ended_at
    self.started_at < Time.zone.now and Time.zone.now <= self.ended_at.end_of_day
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
    return false if matching_direction
    Time.zone.now > deadline
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
