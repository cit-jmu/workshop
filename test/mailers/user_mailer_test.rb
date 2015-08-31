require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  def setup
    @enrollment = enrollments(:george_canvas101_carrier)
    # need to create a section part for the enrollment
    @part = Part.new(
      location: "CIT Room7",
      starts_at: Time.current,
      duration: 30
    )
    @enrollment.section.parts << @part
  end


  test "enroll email" do
    email = UserMailer.enroll_email(@enrollment, @part).deliver_now
    assert_not ActionMailer::Base.deliveries.empty?

    assert_equal ['no-reply@jmu.edu'], email.from
    assert_equal ['george@test.com'], email.to
    assert_equal 'CIT Workshop enrollment for Canvas 101: The Philosophy',
                 email.subject

    assert email.multipart?
    assert_equal 2, email.parts.length

    # the first part is the text, html, and inline ics attachemnt
    assert_match /^multipart\/alternative/, email.parts[0].content_type
    assert_equal 3, email.parts[0].parts.length

    assert_equal 'text/plain; charset=UTF-8',
                 email.parts[0].parts[0].content_type
    #assert_equal read_fixture('enroll_email.text').join,
    #             email.parts[0].parts[0].body.to_s

    assert_equal 'text/html; charset=UTF-8',
                 email.parts[0].parts[1].content_type
    #assert_equal read_fixture('enroll_email.html').join,
    #             email.parts[0].parts[1].body.to_s

    assert_equal 'text/calendar; charset=UTF-8', email.parts[0].parts[2].content_type

    # this is the non-inline attachment.  both inline and non-inline are
    # needed to work with Outlook + other email clients
    assert_equal 'application/ics; charset=UTF-8; name=workshop.ics',
      email.parts[1].content_type
  end

  test "unenroll email" do

  end

  test "reminder email" do

  end

  test "alert email" do

  end

  test "evaluation email" do
    email = UserMailer.evaluation_email(@enrollment).deliver_now
    assert_not ActionMailer::Base.deliveries.empty?

    assert_equal ['no-reply@jmu.edu'], email.from
    assert_equal ['george@test.com'], email.to
    assert_equal 'CIT Workshop evaluation for Canvas 101: The Philosophy',
                 email.subject

    assert email.multipart?
    assert_equal 2, email.parts.length

    assert_equal 'text/plain; charset=UTF-8', email.parts[0].content_type
    assert_equal read_fixture('evaluation_email.text').join, email.parts[0].body.to_s

    assert_equal 'text/html; charset=UTF-8', email.parts[1].content_type
    assert_equal read_fixture('evaluation_email.html').join, email.parts[1].body.to_s
  end
end
