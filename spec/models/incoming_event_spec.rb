require 'spec_helper'

describe IncomingEvent do
	 it { should validate_presence_of :title }
	 it { should belong_to :expected_event }

	 it "has a valid factory" do
	 	FactoryGirl.build(:incoming_event).should be_valid
	 end


	 context 'validating title' do
	 	it 'complains about illegal characters' do
	 		incoming_event = IncomingEvent.new(title: 'bß€se')
	 		incoming_event.valid?
	 		incoming_event.should have(1).error_on(:title)
	 	end

	 	it 'removes trailing white spaces before save' do
	 		incoming_event = IncomingEvent.new(title: ' bose    ')
	 		incoming_event.save
	 		incoming_event.title.should == 'bose'
	 	end
	 end

	 context 'with scopes' do
	 	it 'has a not tracked scope' do
	 		expect(IncomingEvent.not_tracked).to be_kind_of ActiveRecord::Relation
	 	end
	 end

	describe '#track!' do
		it 'assigns the current time' do
			subject.track!
			expect(subject.tracked_at).not_to be_nil
		end

		it 'saves the record' do
			incoming_event = FactoryGirl.build(:incoming_event)
			incoming_event.track!
			expect(incoming_event).to be_persisted
		end
	end
end
