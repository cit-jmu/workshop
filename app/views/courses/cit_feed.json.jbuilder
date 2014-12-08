json.array!(@courses) do |course|
  json.extract! course, :title, :short_title
  json.url course_url(course)
end
