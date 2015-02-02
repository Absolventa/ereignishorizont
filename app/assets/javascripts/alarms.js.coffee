$(document).ready ->

  $('#alarm_action').change ->
    selected = $('#alarm_action option').filter(':selected').text()
    if selected is 'Email'
      $('.for-email').show()
      $('.for-webhook').hide()
    else if selected is 'Webhook'
      $('.for-email').hide()
      $('.for-webhook').show()
    else
      $('.for-email').hide()
      $('.for-webhook').hide()
