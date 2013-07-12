class AlarmTrigger < ActiveRecord::Base
	validates_presence_of :nature
end