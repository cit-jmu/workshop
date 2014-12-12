require 'test_helper'

class CourseTest < ActiveSupport::TestCase
  test "course attributes must not be empty" do
    course = Course.new
    assert course.invalid?
    assert course.errors[:course_number].any?
    assert course.errors[:title].any?
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
    assert_equal "1h 30m", course.duration_in_words
  end
end
