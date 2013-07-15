class ExpectedEvent < ActiveRecord::Base
	validates_presence_of :title
	has_many :alarm_triggers
end
