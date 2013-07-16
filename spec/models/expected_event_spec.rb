require 'spec_helper'

describe ExpectedEvent do
	 it { should have_many :alarms }
	 it { should have_many :incoming_events }
	 it { should validate_presence_of :title }

	 context 'validating title' do
	 	it 'complains about umlauts' do
	 		expected_event = ExpectedEvent.new(title: 'böse')
	 		expected_event.valid?
	 		expected_event.should have(1).error_on(:title)
	 	end
	 end
end