require 'spec_helper'

describe ExpectedEvent do
	 it { should have_many :alarms }
	 it { should have_many :incoming_events }
	 it { should validate_presence_of :title }
end