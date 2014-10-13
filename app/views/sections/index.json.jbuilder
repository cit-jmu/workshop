json.array!(@sections) do |section|
  json.extract! section, :id, :location, :seats, :starts_at, :course_id, :section_number
  json.url course_section_url(section.course, section, format: :json)
end
