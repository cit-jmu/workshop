class UserMailer < ActionMailer::Base
  default from: "no-reply@jmu.edu"

  def enroll_email(user, section)
  	@user = user
  	@course = section.course.title
  	@starts_at = section.starts_at
  	attachments.inline['calendar.ics'] = {:mime_type => 'text/calendar', :content => ical(section).to_ical }
  	mail(to: @user.email, subject: "Enrollment: #{@course}")
  	  #,
  		#content_type: 'text/calendar; method=REQUEST name="calendar.ics"', content_disposition: "attachment; filename=calendar.ics",
  		#content: ical(section).to_ical)
  end

	def ical(section)
	  event = Icalendar::Event.new
	  event.dtstart = section.starts_at.strftime("%Y%m%dT%H%M%S")
	  event.dtend = section.ends_at.strftime("%Y%m%dT%H%M%S")
	  event.summary = section.course.title
	  event.description = section.course.description
	  event.location = section.location
	  event.ip_class = "PUBLIC"
	  event
	end
end
