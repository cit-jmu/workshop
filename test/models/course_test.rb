require 'test_helper'

class CourseTest < ActiveSupport::TestCase
  test "course attributes must not be empty" do
    course = Course.new
    assert course.invalid?
    assert course.errors[:title].any?
    assert course.errors[:description].any?
    assert course.errors[:instructor].any?
    assert course.errors[:duration].any?
  end

  test "course duration must be greater than zero" do
    course = Course.new(title: "Test Course",
                        description: "zzz",
                        instructor: "Herbert Nenninger")
    course.duration = -1
    assert course.invalid?
    assert_equal ["must be greater than 0"], course.errors[:duration]

    course.duration = 0
    assert course.invalid?
    assert_equal ["must be greater than 0"], course.errors[:duration]

    course.duration = 1
    assert course.valid?
  end

  test "course duration must be an integer" do
    course = Course.new(title: "Test Course",
                        description: "zzz",
                        instructor: "Herbert Nenninger")
    course.duration = 0.01
    assert course.invalid?
    assert_equal ["must be an integer"], course.errors[:duration]

    course.duration = 1
    assert course.valid?
  end

  test "course title must be unique" do
    course = Course.new(title: courses(:canvas101).title,
                        description: "zzz",
                        instructor: "Herbert Nenninger",
                        duration: 60)
    assert course.invalid?
    assert_equal ["has already been taken"], course.errors[:title]
  end

  test "course description_html is the description parsed as markdown to html" do
    course = Course.new(title: "Test Course",
                        description: "Hang on to *your* **hat**",
                        instructor: "Herbert Nenninger",
                        duration: 5)
    assert_equal "<p>Hang on to <em>your</em> <strong>hat</strong></p>\n", course.description_html
  end

  test "course summary_html is the summary parsed as markdown to html" do
    course = Course.new(title: "Test Course",
                        summary: "Be a *good* little monkey!",
                        description: "zzz",
                        instructor: "Herbert Nenninger",
                        duration: 5)
    assert_equal "<p>Be a <em>good</em> little monkey!</p>\n", course.summary_html
  end
end
