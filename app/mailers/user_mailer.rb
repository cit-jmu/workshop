class UserMailer < ActionMailer::Base
  default from: "no-reply@jmu.edu"

  def enroll_email(enrollment, part)
    @enrollment = enrollment
    @part = part
    @user = enrollment.user
    @section = enrollment.section
    @course = enrollment.section.course

    attachments['workshop.ics'] = {
      content_type: 'application/ics; name="workshop.ics"',
      content: ical_invite
    }

    subject = "CIT Workshop enrollment for #{@course.title}"
    mail(to: @user.email, subject: subject) do |format|
      format.text
      format.html
      format.ics { render text: ical_invite, content_type: "text/calendar; method=REQUEST"}
    end
  end

  def unenroll_email(enrollment, part)
    @enrollment = enrollment
    @part = part
    @user = enrollment.user
    @section = enrollment.section
    @course = enrollment.section.course

    attachments['workshop.ics'] = {
      content_type: 'application/ics; name="workshop.ics"',
      content: ical_cancel
    }

    subject = "CIT Workshop course drop for #{@course.title}"
    mail(to: @user.email, subject: subject) do |format|
      format.text
      format.html
      format.ics { render text: ical_cancel, content_type: "text/calendar; method=CANCEL"}
    end
  end

  def reminder_email(enrollment)
    @enrollment = enrollment
    @section = enrollment.section
    @course = enrollment.section.course
    @user = enrollment.user

    subject = "CIT Workshop reminder for #{@course.title}"
    mail(to: @user.email, subject: subject)
  end

  private
  def ical_invite
    cal = Icalendar::Calendar.new
    cal.prodid = "-//James Madison University//CIT Workshop//EN"
    cal.ip_method = "REQUEST"
    cal.event do |e|
      e.uid = "#{@enrollment.ical_event_uid}-#{@part.id}@cit.jmu.edu"
      e.dtstart = @part.starts_at.strftime("%Y%m%dT%H%M%S")
      e.dtend = @part.ends_at.strftime("%Y%m%dT%H%M%S")
      e.summary = @course.title
      e.description = @course.summary
      e.location = @part.location
      e.status = "CONFIRMED"
      e.organizer = Icalendar::Values::CalAddress.new("mailto:cit@jmu.edu",
                      cn: "Center for Instructional Technology")
      e.attendee = Icalendar::Values::CalAddress.new("mailto:#{@user.email}",
                     cn: @user.full_name,
                     cutype: "INDIVIDUAL",
                     partstat: "NEEDS-ACTION",
                     role: "REQ-PARTICIPANT")

      # schedule an alarm for 1 day prior to workshop
      e.alarm do |a|
        a.action = "DISPLAY"
        a.summary = "CIT Workshop reminder"
        a.trigger = '-P1DT0H0M0S'
      end
    end
    cal.to_ical
  end

  def ical_cancel
    cal = Icalendar::Calendar.new
    cal.prodid = "-//James Madison University//CIT Workshop//EN"
    cal.ip_method = "CANCEL"
    cal.event do |e|
      e.uid = "#{@enrollment.ical_event_uid}-#{@part.id}@cit.jmu.edu"
      e.dtstart = @part.starts_at.strftime("%Y%m%dT%H%M%S")
      e.dtend = @part.ends_at.strftime("%Y%m%dT%H%M%S")
      e.location = @part.location
      e.status = "CANCELLED"
      e.organizer = Icalendar::Values::CalAddress.new("mailto:cit@jmu.edu",
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
