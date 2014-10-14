class UserMailer < ActionMailer::Base
  default from: "no-reply@jmu.edu"

  def enroll_email(user, section)
  	@user = user
  	@course = section.course.title
  	@date_and_time = section.date_and_time
  	attachments['workshop.ics'] = {:content_type => 'text/calendar; method=REQEST', :content => create_ical(user, section) }
  	mail(to: @user.email, subject: "Enrollment: #{@course}")
  		#, content_type: 'text/calendar; method=REQUEST name="calendar.ics"',
  	  #content_disposition: "inline; filename=calendar.ics", body: '',
  		#content: ical(user, section), encoding: '8bit')
  end

	def create_ical(user, section)
	  cal = Icalendar::Calendar.new
	  cal.event do |e|
		  e.dtstart = section.starts_at.strftime("%Y%m%dT%H%M%S")
		  e.dtend = section.ends_at.strftime("%Y%m%dT%H%M%S")
		  e.summary = section.course.title
		  e.description = section.course.description
		  e.location = section.location
		  e.ip_class = "PUBLIC"
		  e.organizer = "citsupport@jmu.edu"
		  e.attendee = user.email
		end
	  cal.to_ical
	end
end
