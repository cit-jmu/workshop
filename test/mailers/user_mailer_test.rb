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

    body_parts = email.parts[0].parts
    assert_equal 'text/plain; charset=UTF-8', body_parts[0].content_type
    assert_equal 'text/html; charset=UTF-8', body_parts[1].content_type
    assert_equal 'text/calendar; charset=UTF-8', body_parts[2].content_type

    # test the html and text parts for specific content
    body_parts[0..1].each do |part|
      body = part.body.to_s
      assert body.include?('Curious'), 'body should include first name'
      assert body.include?('CIT Room7'), 'body should include location'
      assert body.include?(@part.date_and_time), 'body should include date and time'
      assert body.include?('Canvas 101: The Philosophy'), 'body should include course title'
    end

    # this is the non-inline attachment.  both inline and non-inline are
    # needed to work with Outlook + other email clients
    assert_equal 'application/ics; charset=UTF-8; name=workshop.ics',
      email.parts[1].content_type
  end

  test "unenroll email" do
    email = UserMailer.unenroll_email(@enrollment, @part).deliver_now
    assert_not ActionMailer::Base.deliveries.empty?

    assert_equal ['no-reply@jmu.edu'], email.from
    assert_equal ['george@test.com'], email.to
    assert_equal 'CIT Workshop course drop for Canvas 101: The Philosophy',
                 email.subject

    assert email.multipart?
    assert_equal 2, email.parts.length

    # the first part is the text, html, and inline ics attachemnt
    assert_match /^multipart\/alternative/, email.parts[0].content_type
    assert_equal 3, email.parts[0].parts.length

    body_parts = email.parts[0].parts
    assert_equal 'text/plain; charset=UTF-8', body_parts[0].content_type
    assert_equal 'text/html; charset=UTF-8', body_parts[1].content_type
    assert_equal 'text/calendar; charset=UTF-8', body_parts[2].content_type

    # test the html and text parts for specific content
    body_parts[0..1].each do |part|
      body = part.body.to_s
      assert body.include?('Curious'), 'body should include first name' 
      assert body.include?('Canvas 101: The Philosophy'), 'body should include course title'
    end

    # this is the non-inline attachment.  both inline and non-inline are
    # needed to work with Outlook + other email clients
    assert_equal 'application/ics; charset=UTF-8; name=workshop.ics',
      email.parts[1].content_type
  end

  test "reminder email" do
    email = UserMailer.reminder_email(@enrollment).deliver_now
    assert_not ActionMailer::Base.deliveries.empty?

    assert_equal ['no-reply@jmu.edu'], email.from
    assert_equal ['george@test.com'], email.to
    assert_equal 'CIT Workshop reminder for Canvas 101: The Philosophy',
                 email.subject

    assert email.multipart?
    assert_equal 2, email.parts.length

    assert_equal 'text/plain; charset=UTF-8', email.parts[0].content_type
    assert_equal 'text/html; charset=UTF-8', email.parts[1].content_type

    # make sure that the correct info gets injected into each email body part
    email.parts.each do |part|
      body = part.body.to_s
      # check body for first_name
      assert body.include?('Curious'), 'body should include first name'
      # and course.title
      assert body.include?('Canvas 101: The Philosophy'), 'body should include course title'
    end
  end

  test "alert email" do
    email = UserMailer.alert_email(@enrollment).deliver_now
    assert_not ActionMailer::Base.deliveries.empty?

    assert_equal ['no-reply@jmu.edu'], email.from
    assert_equal ['notify@test.com'], email.to
    assert_equal 'CIT Enrollment Alert for Canvas 101: The Philosophy',
                 email.subject

    assert email.multipart?
    assert_equal 2, email.parts.length

    assert_equal 'text/plain; charset=UTF-8', email.parts[0].content_type
    assert_equal 'text/html; charset=UTF-8', email.parts[1].content_type

    # make sure that the correct info gets injected into each email body part
    email.parts.each do |part|
      body = part.body.to_s
      # check body for first_name
      assert body.include?('Curious'), 'body should include first name'
      # and course.title
      assert body.include?('Canvas 101: The Philosophy'), 'body should include course title'
      # and the user's email
      assert body.include?('george@test.com'), 'body should include user email'
    end

  end

  test "evaluation email is sent when there is an evaluation url" do
    email = UserMailer.evaluation_email(@enrollment).deliver_now
    assert_not ActionMailer::Base.deliveries.empty?

    assert_equal ['no-reply@jmu.edu'], email.from
    assert_equal ['george@test.com'], email.to
    assert_equal 'CIT Workshop evaluation for Canvas 101: The Philosophy',
                 email.subject

    assert email.multipart?
    assert_equal 2, email.parts.length

    assert_equal 'text/plain; charset=UTF-8', email.parts[0].content_type
    assert_equal 'text/html; charset=UTF-8', email.parts[1].content_type

    # make sure that the correct info gets injected into each email body part
    email.parts.each do |part|
      body = part.body.to_s
      # check body for first_name
      assert body.include?('Curious'), 'body should include first name'
      # and course.title
      assert body.include?('Canvas 101: The Philosophy'), 'body should include course title'
      # and the evaluation_url
      assert body.include?('http://jmu.co1.qualtrics.com/SE/?SID=SV_82MNygLpNathnG5&course=Canvas+101%3A+The+Philosophy&enrollment_id=428823752&instructor=Professor+Wiseman'), 'body should include enrollment url'
    end
  end

  test "evaluation email is not sent when there is no evaluation url" do
    Setting.expects(:evaluation_url).returns(nil)
    @enrollment.course.evaluation_url = nil;
    email = UserMailer.evaluation_email(@enrollment).deliver_now
    p email
    assert_nil email
    assert_empty ActionMailer::Base.deliveries
  end

  test "evaluation email is not sent when the Setting evaluation url is an empty string" do
    Setting.expects(:evaluation_url).returns("")
    @enrollment.course.evaluation_url = nil;
    email = UserMailer.evaluation_email(@enrollment).deliver_now
    p email
    assert_nil email
    assert_empty ActionMailer::Base.deliveries
  end

  test "evaluation email is not sent when the course evaluation url is an empty string" do
    @enrollment.course.evaluation_url = "";
    email = UserMailer.evaluation_email(@enrollment).deliver_now
    p email
    assert_nil email
    assert_empty ActionMailer::Base.deliveries
  end

end
