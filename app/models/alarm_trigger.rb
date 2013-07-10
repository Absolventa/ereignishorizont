class AlarmTrigger < ActiveRecord::Base
	validates_presence_of :title, :type

end