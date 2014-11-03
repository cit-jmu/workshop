# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

initialize_datetimepicker = ->
  # initialize the datetime pickers
  console.log "initializing the datetimepicker component"
  $('[data-provides="datetimepicker"]').parents(".date").datetimepicker()

# run the initialize function on page:load from turbolinks
$(document).ready(initialize_datetimepicker)
$(document).on 'page:load', initialize_datetimepicker
