class UserMailer < ActionMailer::Base
  default from: "no-reply@jmu.edu"

  def enroll_email(user, section)
  	@user = user
    @section = section

  	attachments['workshop.ics'] = {
      content_type: 'text/calendar; method=REQEST',
      content: workshop_ical_invite
    }

  	mail(to: @user.email, subject: "CIT Workshop enrollment for #{@section.course.title}")
  		#, content_type: 'text/calendar; method=REQUEST name="calendar.ics"',
  	  #content_disposition: "inline; filename=calendar.ics", body: '',
  		#content: ical(user, section), encoding: '8bit')
  end

	def workshop_ical_invite
	  cal = Icalendar::Calendar.new
    cal.ip_method = "REQUEST"
	  cal.event do |e|
		  e.dtstart = @section.starts_at.strftime("%Y%m%dT%H%M%S")
		  e.dtend = @section.ends_at.strftime("%Y%m%dT%H%M%S")
		  e.summary = @section.course.title
		  e.description = @section.course.summary
		  e.location = @section.location
		  e.ip_class = "PUBLIC"
		  e.organizer = "citsupport@jmu.edu"
		  e.attendee = @user.email
		end
	  cal.to_ical
	end
end
