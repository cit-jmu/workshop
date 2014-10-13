json.array!(@courses) do |course|
  json.extract! course, :id, :title, :description, :duration, :instructor, :summary, :course_number
  json.url course_url(course, format: :json)
end
