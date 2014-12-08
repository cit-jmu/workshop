xml.instruct! :xml, version: "1.0"
xml.rss version: "2.0" do
  xml.channel do
    xml.title "Upcoming CIT Workshops"
    xml.description "Upcoming CIT Workshops"
    xml.link courses_url

    @parts.each do |part|
      course = part.section.course
      xml.item do
        xml.title course.title
        xml.description part.date_and_time
        xml.pubDate course.created_at.to_s(:rfc822)
        xml.link course_url(course)
        xml.guid course_url(course)
      end
    end
  end
end
