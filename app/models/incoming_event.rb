class IncomingEvent < ActiveRecord::Base
	validates_presence_of :title
	belongs_to :expected_event
end
