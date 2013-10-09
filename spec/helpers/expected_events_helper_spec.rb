require 'spec_helper'

describe ExpectedEventsHelper do
  describe '#selected_weekdays' do
    let(:expected_event) { ExpectedEvent.new }

    it 'returns an empty string if no day selected' do
      expect(helper.selected_weekdays(expected_event)).to eql ""
    end

    it 'adds name if selected weekday is true' do
      expected_event.weekday_0 = true
      expect(helper.selected_weekdays(expected_event)).to eql "Sun"
    end

    it 'does not add name if selected weekday is false' do
      expected_event.weekday_0 = false
      expect(helper.selected_weekdays(expected_event)).not_to eql "Sun"
    end

    it 'adds more than one selected weekday' do
      expected_event.weekday_6 = true
      expected_event.weekday_0 = true
      expect(helper.selected_weekdays(expected_event)).to eql "Sun Sat"
    end

    it 'returns "all" when all weekdays are selected' do
      0.upto(6).each do |n|
        expected_event.send("weekday_#{n}=", true)
      end
      expect(helper.selected_weekdays(expected_event)).to eql "all"
    end
  end
end
