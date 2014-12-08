json.array!(@courses) do |course|
  json.title course.title
  json.url course_url(course)
end
