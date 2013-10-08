class Matcher
  class << self
    def run
      expected_events.each do |expected_event|
        if expected_event.deadline_exceeded?
          run_alarms_for expected_event
          track_incoming_events_for expected_event
        end
        # TODO return value?
      end
    end

    def expected_events
      ExpectedEvent.active.today.backward.
        reject{|event| event.alarm_notifications.today.any? }
        # OPTIMIZE: Transform #reject into a proper where statement
    end

    def incoming_events_for expected_event
      IncomingEvent.not_tracked.
        where(title: expected_event.title).
        where("created_at > ? AND created_at <= ?", Time.zone.now.beginning_of_day, expected_event.deadline)
    end

    private

    def run_alarms_for expected_event
      expected_event.alarm! if incoming_events_for(expected_event).empty?
    end

    def track_incoming_events_for expected_event
      incoming_events_for(expected_event).each(&:track!)
    end
  end
end
