# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# when a new 'part' ros is added to a section, setup the datetimepicker
$(document).on 'nested:fieldAdded', (event) ->
  event.field.find('.js-date').datetimepicker()

