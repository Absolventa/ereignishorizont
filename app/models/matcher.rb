class Matcher
  class << self
    def run
      expected_events.each {|expected_event| run_alarms_for expected_event }
    end

    def expected_events
      ExpectedEvent.active.today.backward.includes(:alarm_notifications).
        select do |event|
          event.alarm_notifications.today.where(remote_side: event.remote_side).empty? &&
            event.deadline_exceeded?
        end
    end

    def incoming_events_for expected_event
      IncomingEvent.where(title: expected_event.title).
        where(remote_side: expected_event.remote_side).
        created_today_before(expected_event.deadline)
    end

    private

    def run_alarms_for expected_event
      expected_event.alarm! if incoming_events_for(expected_event).empty?
    end
  end
end
