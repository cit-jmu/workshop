module StatsHelper
  def progress_bar_context(section)
    pct = section.enrollments.count.to_f / section.seats.to_f
    case
    when pct  < 0.5  then " progress-bar-success"
    when pct <= 0.75 then " progress-bar-warning"
    else  " progress-bar-danger"
    end
  end
  def progress_bar_percent(section)
    "#{((section.enrollments.count.to_f / section.seats.to_f) * 100).to_i}%"
  end
end
