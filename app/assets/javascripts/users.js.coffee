# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  if $('#send_invitation').is(':checked') is true
    $('.password').hide()

  $('#send_invitation').change ->
    if $(this).is(':checked') is true
      $('.password').hide()
    else
      $('.password').show()
