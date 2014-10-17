module CoursesHelper
  def css_class_for_section_row(section)
    return "" if !current_user
    case
    when current_user.enrolled?(section)
      "success"
    when current_user.instructing?(section)
      "warning"
    when current_user.enrolled?(section.course)
      "text-muted"
    end
  end
end
