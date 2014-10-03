require 'rails_helper'

RSpec.describe "courses/new", :type => :view do
  before(:each) do
    assign(:course, Course.new(
      :title => "MyString",
      :description => "MyText",
      :duration => 1
    ))
  end

  it "renders new course form" do
    render

    assert_select "form[action=?][method=?]", courses_path, "post" do

      assert_select "input#course_title[name=?]", "course[title]"

      assert_select "textarea#course_description[name=?]", "course[description]"

      assert_select "input#course_duration[name=?]", "course[duration]"
    end
  end
end
