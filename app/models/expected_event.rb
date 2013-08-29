class ExpectedEvent < ActiveRecord::Base
	validates :title, presence: true, format: { with: /\A[a-z0-9\s]+\Z/i }
  	validates_uniqueness_of :title

	has_many :alarms
	has_many :incoming_events

	before_validation :delete_white_spaces_from_title

  validates_inclusion_of :final_hour, in: 1..24 
  #TODO not needed for forward matching?


  #scope :active, -> { where("started_at < ?", Time.now).where("ended_at > ?", Time.now) }
  #scope :forward_matching, -> { where(forward_matching: true) }
  #scope :backward_matching, -> { where(backward_matching: true)}
  #scopes are like normal methods, just different syntax


	def alarm!
		alarms.each { |alarm| alarm.run }
	end

  # (0..6).each do |weekday_index|

  #   # dynamically define method

  #   define_method "hurray_for_weekday_#{weekday_index}!" do
  #     puts "hurray" if self.send("weekday_#{weekday_index}")
  #   end

  # end

  def selected_weekdays
    selected_weekdays = []
    selected_weekdays << "Sun" if self.weekday_0
    selected_weekdays << "Mon" if self.weekday_1
    selected_weekdays << "Tue" if self.weekday_2
    selected_weekdays << "Wed" if self.weekday_3
    selected_weekdays << "Thu" if self.weekday_4
    selected_weekdays << "Fri" if self.weekday_5
    selected_weekdays << "Sat" if self.weekday_6
    selected_weekdays.join(" ")

    # daynames = Date::ABBR_DAYNAMES.dup
    # daynames = daynames[1..-1] << daynames[0]

    # (0..6).map{|i| "weekday_#{i}" }.each_with_index do |weekday, index|
    #   selected_weekdays << daynames[index] if self.send(weekday)
    # end
    # selected_weekdays.join(" ")
  end

  def event_matching_direction
    if self.matching_direction
      "Forward"
    elsif self.matching_direction == false
      "Backward"
    end
  end

  def active?
    return false unless self.started_at and self.ended_at
    self.started_at < Time.now and self.ended_at > Time.now
  end

  def activity_status
    if active?
      "active"
    else
      "inactive"
    end
  end

  def weekday_checker
    self.send("weekday_#{Date.today.wday}")
  end

  def deadline #date and time together
    
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
