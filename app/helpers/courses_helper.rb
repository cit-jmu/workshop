module CoursesHelper
  def css_class_for_section_row(section)
    classes = []
    case
    when section == @enrolled_section
      classes << "success"
    when @enrolled_section
      classes << "text-muted"
    end
    classes.join(' ')
  end
end
