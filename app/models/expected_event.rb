class ExpectedEvent < ActiveRecord::Base
	validates_presence_of :title
	has_many :alarms
end
