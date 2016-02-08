atom_feed do |feed|
  feed.title "#{Rails.application.config.x["identity"]["site_name"]}"
  @courses.each do |course|
    feed.entry course do |entry|
      entry.title course.title
    end
  end
end
