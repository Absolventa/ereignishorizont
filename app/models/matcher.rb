# class Matcher
#   def run
#     ExpectedEvent.active.today.backward.each do |expected_event|
#       incoming_events = IncomingEvent.not_tracked.
#       where(title: expected_event.title).
#       where("created_at > ? AND created_at <= ?", Time.zone.now.beginning_of_day, expected_event.deadline)

#         incoming_events.each do |incoming_event|
#           incoming_event.track!
#         end
#         expected_event.alarm! if incoming_events.empty?
#       end
#     end
#   end

# end

class Matcher
  def run
    expected_events.each do |expected_event|
      incoming_events_for(expected_event).each(&:track!)
      if incoming_events_for(expected_event).empty? and deadline_exceeded?(expected_event)
        expected_event.alarm!
      end
      # TODO return value?
    end
  end

  def expected_events
    ExpectedEvent.active.today.backward
  end

  def incoming_events_for expected_event
    IncomingEvent.not_tracked.
      where(title: expected_event.title).
      where("created_at > ? AND created_at <= ?", Time.zone.now.beginning_of_day, expected_event.deadline)
  end

  private

  def deadline_exceeded? expected_event
    Time.zone.now > expected_event.deadline
  end

end
