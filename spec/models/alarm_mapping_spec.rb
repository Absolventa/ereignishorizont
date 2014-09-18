require 'spec_helper'

describe AlarmMapping, :type => :model do
  it { is_expected.to belong_to :alarm }
  it { is_expected.to belong_to :expected_event }
end
