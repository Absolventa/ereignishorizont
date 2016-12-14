require 'rails_helper'

RSpec.describe Cleanup do
  let(:cutoff_date) { 2.months.ago.to_date }

  subject { described_class.new cutoff_date }

  describe 'its constructor' do
    it 'sets the retention cutoff' do
      subject = described_class.new cutoff_date
      expect(subject.cutoff_date).to eql cutoff_date
    end

    it 'requires a date' do
      [nil, "2015-01-01"].each do |illegal|
        expect { described_class.new illegal }.
          to raise_error ArgumentError
      end

      [DateTime.yesterday, Date.today, 1.day.ago].each do |legal|
        expect { described_class.new legal }.not_to raise_error
      end
    end
  end

  describe '#delete!' do
    let!(:old_event) { create :incoming_event, created_at: 1.year.ago }
    let!(:new_event) { create :incoming_event }

    it 'deletes the old event' do
      expect { subject.delete! }.
        to change { IncomingEvent.count }.by(-1)
    end
  end

end
