class ExpectedEvent < ActiveRecord::Base
	validates_presence_of :title
	validates :title, format: { with: /\A[a-z\s]+\Z/i }

	has_many :alarms
	has_many :incoming_events
end
