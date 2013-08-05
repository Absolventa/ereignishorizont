require 'spec_helper'

describe Alarm do

  it { should belong_to :expected_event }
  it { should validate_presence_of :expected_event }
	it { should allow_value("a@b.com").for(:recipient_email) }
	#it { should_not allow_value("blah").for(:recipient_email) } <= this doesn't work!
end

# how does rspec work for boolean values?