json.array!(@parts) do |part|
  json.title part.section.course.title
  json.datetime part.date_and_time
  json.url course_url(part.section.course)
end
