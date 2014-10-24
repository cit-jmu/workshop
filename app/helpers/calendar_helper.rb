module CalendarHelper
  def css_classes_for_cal_event(section)
    return "" if !current_user
    case
    when current_user.enrolled?(section)
      "enrolled"
    when current_user.instructing?(section)
      "instructing"
    end
  end

  def cal_previous_link
    ->(param, date_range) {
      link_to url_for({ param => date_range.first - 1.day }) do
        '<span class="glyphicon glyphicon-circle-arrow-left"></span>'.html_safe
      end
    }
  end

  def cal_next_link
    ->(param, date_range) {
      link_to url_for({ param => date_range.last + 1.day }) do
        '<span class="glyphicon glyphicon-circle-arrow-right"></span>'.html_safe
      end
    }
  end

  def cal_title
    ->(start_date) {
      content_tag :span, "#{I18n.t("date.month_names")[start_date.month]} #{start_date.year}",
                  class: "cal-title"
    }
  end
end
