$(document).ready ->

  $('#alarm_action').change ->
    selected = $('#alarm_action option').filter(':selected').text()
    if selected is 'Email'
      $('.for-email').show()
    else
      $('.for-email').hide()
