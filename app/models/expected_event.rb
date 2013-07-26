class ExpectedEvent < ActiveRecord::Base
	validates :title, presence: true, format: { with: /\A[a-z0-9\s]+\Z/i }
  	validates_uniqueness_of :title

	has_many :alarms
	has_many :incoming_events

	before_save :delete_white_spaces_from_title

	def alarm!
		alarms.each do |alarm|
			alarm.run
		end
	end

  private
    def delete_white_spaces_from_title
      self.title = self.title.strip
    end
end
