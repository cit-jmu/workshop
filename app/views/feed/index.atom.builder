identity = Rails.application.config.x["identity"]
atom_feed do |feed|
  feed.title "#{identity["site_name"]}"
  @courses.each do |course|
    feed.entry course do |entry|
      entry.title course.title
    end
  end
end
