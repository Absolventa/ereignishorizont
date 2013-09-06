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
      # incoming_events_for(expected_event).each do |incoming_event|
      #   incoming_event.track!
      # end

      incoming_events_for(expected_event).each(&:track!)
      #expected_event.alarm! if incoming_events_for(expected_events).empty?
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
end