require 'test_helper'

class CourseTest < ActiveSupport::TestCase
  test "course attributes must not be empty" do
    course = Course.new
    assert course.invalid?
    assert course.errors[:course_number].any?
    assert course.errors[:title].any?
    assert course.errors[:short_title].any?
    assert course.errors[:summary].any?
    assert course.errors[:description].any?
  end

  test "course title must be unique" do
    course = Course.new(title: courses(:canvas101).title,
                        course_number: "CITTEST",
                        description: "zzz")
    assert course.invalid?
    assert_equal ["has already been taken"], course.errors[:title]
  end

  test "course description_html is the description parsed as markdown to html" do
    course = Course.new(title: "Test Course",
                        course_number: "CITTEST",
                        description: "Hang on to *your* **hat**")
    assert_equal "<p>Hang on to <em>your</em> <strong>hat</strong></p>\n", course.description_html
  end

  test "course number must be unique" do
    course = Course.new(title: "Test Course",
                        course_number: courses(:canvas101).course_number,
                        description: "zzz")
    assert course.invalid?
    assert_equal ["has already been taken"], course.errors[:course_number]
  end

  test "duration is pulled from the first section" do
    course = courses(:canvas101)
    assert_equal course.sections.first.duration, course.duration
  end

  test "duration_in_words makes long durations readable" do
    course = courses(:canvas113)
    # add a part to the course so we can get a duration
    Part.create!(
      location: 'Room 7',
      starts_at: Time.current,
      duration: 90,
      section: course.sections.first
    )

    assert_equal "1h 30m", course.duration_in_words
  end

  test "short_title is set to title value if not present" do
    course = Course.new(
      title: 'Testing w/Rails 101',
      course_number: 'TEST001',
      description: 'Just a test course :)',
      summary: 'Test with Rails'
    )
    course.save
    assert_equal course.title, course.short_title
  end

  test "short_title is 30 chars max" do
    course = Course.new(
      title: 'Testing w/Rails 101',
      short_title: 'This title is not short and should fail validation',
      course_number: 'TEST001',
      description: 'Just a test course :)',
      summary: 'Test with Rails'
    )
    assert course.invalid?
    assert_equal ["is too long (maximum is 30 characters)"],
                 course.errors[:short_title]
  end

  test "course is not current when it has no sections" do
    course = Course.new(
      title: 'Testing w/Rails 101',
      course_number: 'TEST001',
      description: 'Just a test course :)',
      summary: 'Test with Rails'
    )
    assert_not course.current?
  end

  test "course is not current when it has no current sections" do
    # the fixtures don't add any parts to the sections, so the
    # :canvas101 course fixture should just have empty sections,
    # which should not be 'current'
    course = courses(:canvas101)
    assert_not course.current?
  end

  test "course is current when it has current sections" do
    course = courses(:canvas101)
    # need to add a part so it can be current
    Part.create!(
      location: 'Room 7',
      starts_at: Time.current,
      duration: 30,
      section: course.sections.first
    )
    assert course.current?
  end
end
