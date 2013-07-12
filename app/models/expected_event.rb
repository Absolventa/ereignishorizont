class ExpectedEvent < ActiveRecord::Base
	validates_presence_of :event
	has_many :alarm_triggers
end
