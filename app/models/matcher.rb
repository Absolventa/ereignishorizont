class Matcher
  class << self
    def run
      expected_events.each do |expected_event|
        run_alarms_for expected_event
      end
    end

    def expected_events
      ExpectedEvent.active.today.backward.
        select do |event|
          event.alarm_notifications.today.empty? && event.deadline_exceeded?
        end
    end

    def incoming_events_for expected_event
      IncomingEvent.where(title: expected_event.title).
        where("created_at > ? AND created_at <= ?", Time.zone.now.beginning_of_day, expected_event.deadline)
    end

    private

    def run_alarms_for expected_event
      expected_event.alarm! if incoming_events_for(expected_event).empty?
    end
  end
end
