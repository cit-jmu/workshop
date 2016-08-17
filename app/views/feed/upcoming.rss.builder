xml.instruct! :xml, version: "1.0"
xml.rss version: "2.0" do
  xml.channel do
    xml.title "Upcoming #{Rails.application.config.x["terminology"]["workshop"].pluralize}"
    xml.description "Upcoming #{Rails.application.config.x["terminology"]["workshop"].pluralize}"
    xml.link courses_url

    @parts.each do |part|
      course = part.section.course
      xml.item do
        xml.title part.feed_title
        xml.description part.feed_description
        xml.pubDate part.feed_pubdate
        xml.link course_url(course)
        xml.guid course_url(course)
      end
    end
  end
end
