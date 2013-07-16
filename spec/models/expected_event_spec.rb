require 'spec_helper'

describe ExpectedEvent do
	 it { should have_many :alarms }
	 it { should have_many :incoming_events }
	 it { should validate_presence_of :title }

	 context 'validating title' do
	 	it 'complains about illegal characters' do
	 		expected_event = ExpectedEvent.new(title: 'bß€se')
	 		expected_event.valid?
	 		expected_event.should have(1).error_on(:title)
	 	end

	 	it 'removes trailing white spaces before save' do
	 		expected_event = ExpectedEvent.new(title: ' bose    ')
	 		expected_event.save
	 		expected_event.title.should == 'bose'
	 	end
	 end
end