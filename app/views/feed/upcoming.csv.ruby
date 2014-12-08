CSV.generate do |csv|
  csv << ['Title', 'URL', 'DateTime']
  @parts.each do |part|
    csv << [
      part.section.course.title,
      course_url(part.section.course),
      part.date_and_time
    ]
  end
end

