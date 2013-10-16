require 'spec_helper'

describe AlarmMapping do
  it { should belong_to :alarm }
  it { should belong_to :expected_event }
end
