class Alarm < ActiveRecord::Base
	validates_presence_of :nature
	belongs_to :expected_event
end