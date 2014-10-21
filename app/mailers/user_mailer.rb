class UserMailer < ActionMailer::Base
  default from: "no-reply@jmu.edu"

  def enroll_email(enrollment)
    @enrollment = enrollment
    @user = enrollment.user
    @section = enrollment.section
    @course = enrollment.section.course

  	attachments['workshop.ics'] = {
      content_type: 'application/ics; name="workshop.ics"',
      content: ical_invite
    }

  	mail(to: @user.email, subject: "CIT Workshop enrollment for #{@course.title}") do |format|
      format.text
      format.html
      format.ics { render text: ical_invite, content_type: "text/calendar; method=REQUEST"}
    end
  end

  def unenroll_email(enrollment)
    @enrollment = enrollment
    @user = enrollment.user
    @section = enrollment.section
    @course = enrollment.section.course

  	attachments['workshop.ics'] = {
      content_type: 'application/ics; name="workshop.ics"',
      content: ical_cancel
    }

  	mail(to: @user.email, subject: "CIT Workshop course drop for #{@course.title}") do |format|
      format.text
      format.html
      format.ics { render text: ical_cancel, content_type: "text/calendar; method=CANCEL"}
    end
  end

  private
  	def ical_invite
  	  cal = Icalendar::Calendar.new
      cal.prodid = "-//James Madison University//CIT Workshop//EN"
      cal.ip_method = "REQUEST"
  	  cal.event do |e|
        e.uid = @enrollment.ical_event_uid
  		  e.dtstart = @section.parts.first.starts_at.strftime("%Y%m%dT%H%M%S")
  		  e.dtend = @section.parts.first.ends_at.strftime("%Y%m%dT%H%M%S")
  		  e.summary = @course.title
  		  e.description = @course.summary
  		  e.location = @section.location
        e.status = "CONFIRMED"
  		  e.organizer = Icalendar::Values::CalAddress.new("mailto:citsupport@jmu.edu",
                        cn: "Center for Instructional Technology")
  		  e.attendee = Icalendar::Values::CalAddress.new("mailto:#{@user.email}",
                       cn: @user.full_name,
                       cutype: "INDIVIDUAL",
                       partstat: "NEEDS-ACTION",
                       role: "REQ-PARTICIPANT")
  		end
  	  cal.to_ical
  	end

    def ical_cancel
  	  cal = Icalendar::Calendar.new
      cal.prodid = "-//James Madison University//CIT Workshop//EN"
      cal.ip_method = "CANCEL"
  	  cal.event do |e|
        e.uid = @enrollment.ical_event_uid
  		  e.dtstart = @section.parts.first.starts_at.strftime("%Y%m%dT%H%M%S")
  		  e.dtend = @section.parts.first.ends_at.strftime("%Y%m%dT%H%M%S")
  		  e.location = @section.location
        e.status = "CANCELLED"
  		  e.organizer = Icalendar::Values::CalAddress.new("mailto:citsupport@jmu.edu",
                        cn: "Center for Instructional Technology")
  		  e.attendee = Icalendar::Values::CalAddress.new("mailto:#{@user.email}",
                       cn: @user.full_name,
                       cutype: "INDIVIDUAL",
                       partstat: "NEEDS-ACTION",
                       role: "REQ-PARTICIPANT")
  		end
  	  cal.to_ical
  	end
end
