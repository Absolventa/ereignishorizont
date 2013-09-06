module ExpectedEventSpecHelper

  def activate_current_weekday_for expected_event
    expected_event.send("weekday_#{Date.today.wday}=", true)
    expected_event
  end

  def activate_current_weekday_for! expected_event
    expected_event = activate_current_weekday_for expected_event
    expected_event.save
    expected_event
  end
end