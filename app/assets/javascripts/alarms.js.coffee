$(document).ready ->

  $('#alarm_action').change ->
    selected = $('#alarm_action option').filter(':selected').text()
    if selected is 'email'
      $('.for-email').show()
      $('.for-webhook').hide()
    else if selected is 'webhook'
      $('.for-email').hide()
      $('.for-webhook').show()
    else
      $('.for-email').hide()
      $('.for-webhook').hide()
