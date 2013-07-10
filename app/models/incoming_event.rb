class IncomingEvent < ActiveRecord::Base
	validates_presence_of :event
end
