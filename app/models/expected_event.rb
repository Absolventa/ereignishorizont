class ExpectedEvent < ActiveRecord::Base
	validates :title, presence: true, format: { with: /\A[a-z0-9\s]+\Z/i }

	has_many :alarms
	has_many :incoming_events
end
