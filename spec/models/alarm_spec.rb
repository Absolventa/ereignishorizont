require 'spec_helper'

describe Alarm do
  it { should belong_to :expected_event }
  it { should validate_presence_of :expected_event }
end