class UserMailer < ActionMailer::Base
  default from: "#{Rails.application.config.x["identity"]["replyto"]}",
            cc: "#{Rails.application.config.x["identity"]["ccto"]}"

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

    subject = "#{Rails.application.config.x["terminology"]["workshop"]} enrollment for #{@course.title}"
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

    subject = "#{Rails.application.config.x["terminology"]["workshop"]} course drop for #{@course.title}"
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

    subject = "#{Rails.application.config.x["terminology"]["workshop"]} reminder for #{@course.title}"
    mail(to: @user.email, subject: subject)
  end

  def alert_email(enrollment)
    @enrollment = enrollment
    @section = enrollment.section
    @course = enrollment.section.course
    @user = enrollment.user
    @alert_email = enrollment.section.alert_email

    subject = "Enrollment Alert for #{@course.title}"
    mail(to: @alert_email, subject: subject)
  end

  def evaluation_email(enrollment)
    # grab the evaluation_url from either the course or main settings
    evaluation_url = enrollment.course.evaluation_url || Setting.evaluation_url
    # only setup and send the evaluation mail if we have a URL
    if !evaluation_url.blank?
      @user = enrollment.user
      @course = enrollment.course
      @section = enrollment.section

      # this is Embedded Data for the Qualtrics survey
      # http://www.qualtrics.com/university/researchsuite/advanced-building/survey-flow/embedded-data/
      embedded_data = {}
      embedded_data[:course]        = @course.title
      embedded_data[:instructor]    = @section.instructor.display_name
      embedded_data[:enrollment_id] = enrollment.id
      
      # append the embedded data to the evaluation url as query params
      @evaluation_url = "#{evaluation_url}&#{embedded_data.to_query}"

      subject = "#{Rails.application.config.x["terminology"]["workshop"]} evaluation for #{@course.title}"
      mail(to: @user.email, subject: subject)
    end
  end

  private
  def ical_invite
    cal = Icalendar::Calendar.new
    cal.prodid = "-//James Madison University//#{Rails.application.config.x["identity"]["site_name"]}//EN"
    cal.ip_method = "REQUEST"
    cal.event do |e|
      e.uid = "#{@enrollment.ical_event_uid}-#{@part.id}-#{Rails.application.config.x["identity"]["replyto"]}"
      e.dtstart = @part.starts_at.strftime("%Y%m%dT%H%M%S")
      e.dtend = @part.ends_at.strftime("%Y%m%dT%H%M%S")
      e.summary = @course.title
      e.description = @course.summary
      e.location = @part.location
      e.status = "CONFIRMED"
      e.organizer = Icalendar::Values::CalAddress.new("mailto:#{Rails.application.config.x["identity"]["replyto"]}",
                      cn: "#{Rails.application.config.x["identity"]["site_owner"]}")
      e.attendee = Icalendar::Values::CalAddress.new("mailto:#{@user.email}",
                     cn: @user.full_name,
                     cutype: "INDIVIDUAL",
                     partstat: "NEEDS-ACTION",
                     role: "REQ-PARTICIPANT")

      # schedule an alarm for 1 day prior to workshop
      e.alarm do |a|
        a.action = "DISPLAY"
        a.summary = "#{Rails.application.config.x["terminology"]["workshop"]} reminder"
        a.trigger = '-P1DT0H0M0S'
      end
    end
    cal.to_ical
  end

  def ical_cancel
    cal = Icalendar::Calendar.new
    cal.prodid = "-//James Madison University//#{Rails.application.config.x["identity"]["site_name"]}//EN"
    cal.ip_method = "CANCEL"
    cal.event do |e|
      e.uid = "#{@enrollment.ical_event_uid}-#{@part.id}-#{Rails.application.config.x["identity"]["replyto"]}"
      e.dtstart = @part.starts_at.strftime("%Y%m%dT%H%M%S")
      e.dtend = @part.ends_at.strftime("%Y%m%dT%H%M%S")
      e.location = @part.location
      e.status = "CANCELLED"
      e.organizer = Icalendar::Values::CalAddress.new("mailto:#{Rails.application.config.x["identity"]["replyto"]}",
                      cn: "#{Rails.application.config.x["identity"]["site_owner"]}")
      e.attendee = Icalendar::Values::CalAddress.new("mailto:#{@user.email}",
                     cn: @user.full_name,
                     cutype: "INDIVIDUAL",
                     partstat: "NEEDS-ACTION",
                     role: "REQ-PARTICIPANT")
    end
    cal.to_ical
  end
end
