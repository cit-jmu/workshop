module CoursesHelper
  def classes_for_course(course)
    return "" unless @user
    case
    when @user.enrolled?(:course => course)
      "enrolled"
    when @user.instructing?(:course => course)
      "instructing"
    end
  end
end
