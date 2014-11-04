module SectionsHelper
  def css_classes_for_section_row(section)
    return "" if !current_user
    case
    when current_user.enrolled?(:section => section)
      "bg-success"
    when current_user.instructing?(:section => section)
      "bg-warning"
    when current_user.enrolled?(:course => section.course)
      "text-muted"
    end
  end
end
