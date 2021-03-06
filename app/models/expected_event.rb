class ExpectedEvent < ApplicationRecord

  # associations
  #
  #

  belongs_to :remote_side, inverse_of: :expected_events

  has_many :alarm_mappings, dependent: :destroy
  has_many :alarms, through: :alarm_mappings
  has_many :alarm_notifications, dependent: :destroy
  has_many :incoming_events

  # validations
  #
  #

  validates :remote_side, presence: true
  validates :title, presence: true, format: { with: IncomingEvent::FORMAT }
  validates :matching_direction, inclusion: { in: %w(backward forward) }
  validates :day_of_month, numericality: { only_integer: true, within: 1..31, allow_blank: true }
  validates_uniqueness_of :title, scope: :remote_side_id
  validates_inclusion_of :final_hour, in: 0..23
  # TODO not needed for forward matching?
  validate :ensure_either_weekly_or_monthly_is_selected

  # scopes
  #
  #

  scope :active,   -> do
    where(<<-EOFSQL, q: Time.now.utc)
    (started_at < :q AND ended_at > :q)
      OR (started_at < :q AND ended_at IS NULL)
      OR (started_at IS NULL AND ended_at IS NULL)
    EOFSQL
  end
  scope :forward,  -> { where(matching_direction: 'forward') }
  scope :backward, -> { where(matching_direction: 'backward') }
  scope :today,    -> { where("weekday_#{Time.now.utc.wday} = :t OR day_of_month = :d", t: true, d: Time.now.utc.day) }

  # callbacks
  #
  #

  before_validation :delete_white_spaces_from_title

  # instance methods
  #
  #

  def alarm!(incoming_event: IncomingEvent.new)
    alarms.each { |alarm| alarm.with_incoming_event(incoming_event).run self }
    AlarmNotification.create(expected_event: self, remote_side: remote_side)
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
    started_at.to_time(:utc) < Time.now.utc and (ended_at.nil? || Time.now.utc <= ended_at.to_time(:utc).end_of_day)
  end

  def activity_status
    if active?
      "active"
    else
      "inactive"
    end
  end

  def checked_today?
    weekdays[Time.now.utc.wday]
  end

  def deadline
    if checked_today?
      Time.now.utc.beginning_of_day + final_hour.hours
    elsif monthly?
      DateTime.new(Date.today.year, Date.today.month, day_of_month, final_hour).utc
    else
      Time.now.utc.beginning_of_day
    end
  end

  def deadline_exceeded?
    return false if matching_direction == 'forward'
    Time.now.utc > deadline
  end

  def last_alarm_at
    last_alarm = alarm_notifications.order(:created_at).last
    last_alarm.created_at if last_alarm
  end

  def monthly?
    !!day_of_month && weekdays.none?
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

  def weekly?
    day_of_month.blank?
  end

  private

  def delete_white_spaces_from_title
    self.title = self.title.strip if self.title
  end

  def ensure_either_weekly_or_monthly_is_selected
    unless weekly? ^ monthly?
      errors.add(:base, 'cannot select both day of month and weekday(s)')
    end
  end

end
