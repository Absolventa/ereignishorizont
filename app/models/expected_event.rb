class ExpectedEvent < ActiveRecord::Base
	validates :title, presence: true, format: { with: /\A[a-z0-9\s]+\Z/i }
  	validates_uniqueness_of :title

	has_many :alarms
	has_many :incoming_events

	before_save :delete_white_spaces_from_title

  scope :active, -> { where("started_at < ?", Time.now).where("ended_at > ?", Time.now) }
  scope :forward_matching, -> { where(forward_matching: true) }
  scope :backward_matching, -> { where(backward_matching: true)}


	def alarm!
		alarms.each do |alarm|
			alarm.run
		end
	end

  def selected_weekdays
    selected_weekdays = ""
    selected_weekdays += " Mon" if self.weekday_0 == true
    selected_weekdays += " Tue" if self.weekday_1 == true
    selected_weekdays += " Wed" if self.weekday_2 == true
    selected_weekdays += " Thu" if self.weekday_3 == true
    selected_weekdays += " Fri" if self.weekday_4 == true
    selected_weekdays += " Sat" if self.weekday_5 == true
    selected_weekdays += " Sun" if self.weekday_6 == true
    selected_weekdays
  end

  private
    def delete_white_spaces_from_title
      self.title = self.title.strip
    end
end
