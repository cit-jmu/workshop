CSV.generate do |csv|
  csv << ['Title', 'URL']
  @courses.each do |course|
    csv << [course.title, course_url(course)]
  end
end

