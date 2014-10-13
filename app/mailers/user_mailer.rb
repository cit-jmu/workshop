class UserMailer < ActionMailer::Base
  default from: "no-reply@jmu.edu"

  def enroll_email(user, section)
  	@user = user
  	@course = section.course.title
  	@date_and_time = section.date_and_time
  	attachments.inline['calendar.ics'] = {:content_type => 'text/calendar; method=REQEST', :content => ical(user, section) }
  	mail(to: @user.email, subject: "Enrollment: #{@course}")
  		#, content_type: 'text/calendar; method=REQUEST name="calendar.ics"',
  	  #content_disposition: "inline; filename=calendar.ics", body: '',
  		#content: ical(user, section), encoding: '8bit')
  end

	def ical(user, section)
	  event = Icalendar::Event.new
	  event.dtstart = section.starts_at.strftime("%Y%m%dT%H%M%S")
	  event.dtend = section.ends_at.strftime("%Y%m%dT%H%M%S")
	  event.summary = section.course.title
	  event.description = section.course.description
	  event.location = section.location
	  event.ip_class = "PUBLIC"
	  event.organizer = "citsupport@jmu.edu"
	  event.attendee = user.email
	  event.to_ical
	end
end
