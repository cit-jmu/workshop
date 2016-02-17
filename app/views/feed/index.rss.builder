xml.instruct! :xml, version: "1.0"
xml.rss version: "2.0" do
  xml.channel do
    xml.title "#{Rails.application.config.x["identity"]["site_name"]}"
    xml.description "Available #{Rails.application.config.x["terminology"]["workshop"].pluralize}"
    xml.link courses_url

    @courses.each do |course|
      xml.item do
        xml.title course.title
        xml.pubDate course.created_at.to_s(:rfc822)
        xml.link course_url(course)
        xml.guid course_url(course)
      end
    end
  end
end
