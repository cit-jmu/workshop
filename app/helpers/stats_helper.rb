module StatsHelper
  def progress_bar_context(section)
    pct = section.enrollments.active.count.to_f / section.seats.to_f
    case
    when pct  < 0.5  then " progress-bar-success"
    when pct <= 0.75 then " progress-bar-warning"
    else " progress-bar-danger"
    end
  end
  def progress_bar_percent(section)
    count = section.enrollments.active.count.to_f
    seats = section.seats.to_f
    "#{((count / seats) * 100).to_i}%"
  end
end
