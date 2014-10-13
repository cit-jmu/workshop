# remove the default 'field_with_errors' class on field errors
ActionView::Base.field_error_proc = Proc.new { |html_tag, instance|
  html_tag.html_safe
}
