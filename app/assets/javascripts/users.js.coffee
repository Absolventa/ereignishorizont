$(document).ready ->
  if $('#send_invitation').is(':checked') is true
    $('.password').hide()

  $('#send_invitation').change ->
    if $(this).is(':checked') is true
      $('.password').hide()
    else
      $('.password').show()
