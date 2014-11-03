# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

initialize_datetimepicker = ->
  # initialize the datetime pickers
  $('[data-provides="datetimepicker"]').parents(".date").datetimepicker()

# run the initializer when the page is loaded
$(document).ready(initialize_datetimepicker)

# run the initialize function on page:load from turbolinks
$(document).on 'page:load', initialize_datetimepicker

# when a new row is added, init the picker for that row
$(document).on 'nested:fieldAdded', (event) ->
  event.field.find('.date').datetimepicker()
