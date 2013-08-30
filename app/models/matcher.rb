class Matcher
  def run
    ExpectedEvent.active.today.backward.each do |expected_event|
      incoming_events = IncomingEvent.where(tracked_at: nil).where
        (title: expected_event.title).where
        ("created_at > ? AND created_at <= ?", Time.zone.now.beginning_of_day, expected_event.deadline)

        incoming_events.each do |incoming_event|
          incoming_event.track!
        end
        expected_event.alarm! if incoming_events.empty?
      end
    end
  end
end