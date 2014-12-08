atom_feed do |feed|
  feed.title "CIT Workshops"
  @courses.each do |course|
    feed.entry course do |entry|
      entry.title course.title
    end
  end
end
