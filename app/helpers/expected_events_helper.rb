module ExpectedEventsHelper

  def selected_weekdays expected_event
    selected_weekdays = []
    selected_weekdays << "Sun" if expected_event.weekday_0
    selected_weekdays << "Mon" if expected_event.weekday_1
    selected_weekdays << "Tue" if expected_event.weekday_2
    selected_weekdays << "Wed" if expected_event.weekday_3
    selected_weekdays << "Thu" if expected_event.weekday_4
    selected_weekdays << "Fri" if expected_event.weekday_5
    selected_weekdays << "Sat" if expected_event.weekday_6

    if selected_weekdays.empty?
      'none'
    elsif selected_weekdays.size == 7
      'all'
    elsif selected_weekdays[0..-1] == %w(Mon Tue Wed Thu Fri)
      'workdays'
    else
      selected_weekdays.join(" ")
    end
  end

end
