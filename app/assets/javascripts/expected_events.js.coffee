# FIX: needs a browser refresh to work
$(document).ready ->
  console.log("HALLO")
  $('#expected_event_started_at').datepicker({ dateFormat: "yy-mm-dd" })
  $('#expected_event_ended_at').datepicker({ dateFormat: "yy-mm-dd" })

