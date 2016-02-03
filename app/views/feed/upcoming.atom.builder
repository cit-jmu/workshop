identity = Rails.application.config.x["identity"]
atom_feed do |feed|
  feed.title "#{identity["site_name"]}"
  @parts.each do |part|
    feed.entry(part, url: course_url(part.section.course)) do |entry|
      entry.title part.section.course.title
      entry.content part.date_and_time
    end
  end
end
