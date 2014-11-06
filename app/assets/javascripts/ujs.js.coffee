# this file contains initializers and setups for functionality described
# through HTML attributes for 'unobtrusive' activation

# main initializer
initialize = ->
  initialize_tooltips()
  initialize_datetimepicker()

# initializer for tooltips
initialize_tooltips = ->
  $('[data-toggle="tooltip"]').tooltip()

# initialize the datetime pickers
initialize_datetimepicker = ->
  $('[data-provides="datetimepicker"]').parents(".js-date").datetimepicker()

# initialize through the jQuery ready() method, and also on 'page:load'
# for integration with TurboLinks
$(document).ready(initialize)
$(document).on 'page:load', initialize
