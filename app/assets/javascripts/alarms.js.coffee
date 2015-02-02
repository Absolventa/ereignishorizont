$(document).ready ->

  $('#alarm_action').change ->
    selected = $('#alarm_action option').filter(':selected').text()
    if selected is 'Email'
      $('.for-email').show()
      $('.for-webhook').hide()
      $('.for-slack').hide()
    else if selected is 'Webhook'
      $('.for-email').hide()
      $('.for-webhook').show()
      $('.for-slack').hide()
    else if selected is 'Slack'
      $('.for-email').hide()
      $('.for-webhook').hide()
      $('.for-slack').show()
    else
      $('.for-email').hide()
      $('.for-webhook').hide()
      $('.for-slack').hide()
