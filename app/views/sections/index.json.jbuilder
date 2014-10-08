json.array!(@sections) do |section|
  json.extract! section, :id, :location, :seats, :starts_at, :course_id
  json.url section_url(section, format: :json)
end
