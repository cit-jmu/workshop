# remove the default 'field_with_errors' class on field errors
Rails.application.config.action_view.field_error_proc = Proc.new { |html_tag, instance|
  html_tag.html_safe
}
