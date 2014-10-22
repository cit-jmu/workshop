module SectionsHelper
  def css_classes_for_section_row(section)
    return "" if !current_user
    case
    when current_user.enrolled?(section)
      "bg-success"
    when current_user.instructing?(section)
      "bg-warning"
    when current_user.enrolled?(section.course)
      "text-muted"
    end
  end
end
