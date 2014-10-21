# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Clear out existing data
Enrollment.delete_all
Part.delete_all
Section.delete_all
Course.delete_all
User.delete_all

# Set developer accounts as admins and create test users that locally authenticate
User.create!([
  {
    username: 'shortjw',
    role: :admin
  },
  {
    username: 'shanklt',
    role: :admin
  }
])
# save these users into variables so we can use them in later seeds
test_admin = User.create!(
  username: 'admin',
  first_name: 'Test',
  last_name: 'Admin',
  email: 'test-admin@example.org',
  password: 'testadmin',
  password_confirmation: 'testadmin',
  role: :admin
)
test_instructor = User.create!(
  username: 'instructor',
  first_name: 'Test',
  last_name: 'Instructor',
  email: 'test-instructor@example.org',
  password: 'testinstructor',
  password_confirmation: 'testinstructor',
  role: :instructor
)
test_participant = User.create!(
  username: 'participant',
  first_name: 'Test',
  last_name: 'Participant',
  email: 'test-participant@example.org',
  password: 'testparticipant',
  password_confirmation: 'testparticipant',
  role: :participant
)

# Canvas 101: The Philosophy
canvas101 = Course.create!(title: 'Canvas 101: The Philosophy',
  course_number: 'CIT001',
  summary: %{Canvas is different! In this one hour session, you will
develop a roadmap for designing your course in a way that benefits you AND
your students.},
  description: %{Canvas ***IS*** different! In this one hour session, you will
develop a roadmap for designing your course in a way that benefits you AND
your students.

# Objectives
At the completion of this workshop, you will be able to:

- Understand how Canvas will benefit you
- Discuss and apply instructional design principles related to building a course in Canvas
- Construct an organizational plan for your course

# Recommended Prerequisites
- Canvas Orientation},
  duration: 60)
canvas101.sections.create!([
    {
      section_number: '0001',
      seats: 25,
      parts_attributes: [{
        instructor: test_instructor,
        location: 'Carrier Library Room 37',
        starts_at: '2014-12-09 14:00:00'
      },
      {
        instructor: test_instructor,
        location: 'Carrier Library Room 37',
        starts_at: '2014-12-11 09:00:00'
      }]
    },
    {
      section_number: '0002',
      seats: 25,
      parts_attributes: [{
        instructor: test_instructor,
        location: 'Rose Library Room 5308',
        starts_at: '2014-12-16 09:00:00'
      },{
        instructor: test_instructor,
        location: 'Rose Library Room 5308',
        starts_at: '2014-12-17 14:00:00'
      }]
    }
])

# Canvas 113: Creating and Managing Content
canvas113 = Course.create!(title: 'Canvas 113: Creating and Managing Content',
  course_number: 'CIT002',
  summary: %{Do you have course content files that need to make their way
into Canvas? In this session you will add and organize content in your
course.},
  description: %{Do you have course content files that need to make their way
into Canvas? In this session you will add and organize content in your
course.

# Objectives
At the completion of this workshop, you will be able to:

- Add files
- Add modules
- Create and populate course with content including: links, videos, wikis, and pages

# Recommended Prerequisites
- Canvas Orientation
- Canvas 101: The Philosophy},
  duration: 60)
canvas113.sections.create!([
    {
      section_number: '0001',
      seats: 25,
      parts_attributes: [{
        instructor: test_instructor,
        location: 'Carrier Library Room 37',
        starts_at: '2014-12-10 14:00:00'
      }]
    },
    {
      section_number: '0002',
      seats: 25,
      parts_attributes: [{
        instructor: test_instructor,
        location: 'Rose Library Room 5308',
        starts_at: '2014-12-17 09:00:00',
      }]
    }
])

# Canvas 211: Communication
canvas211 = Course.create!(title: 'Canvas 211: Communication',
  course_number: 'CIT003',
  summary: %{Explore the many avenues for interaction and communication:
instructor-student, student-student, and student-content.},
  description: %{Explore the many avenues for interaction and communication:
instructor-student, student-student, and student-content.

# Objectives
At the completion of this workshop, you will be able to:

- Create announcements
- Send messages with the Inbox
- Use the Chat feature
- Use the Syllabus
- Explore discussion board uses

# Recommended Prerequisites
- Canvas Orientation
- Canvas 101: The Philosophy},
  duration: 60)
canvas211.sections.create!([
    {
      section_number: '0001',
      seats: 25,
      parts_attributes: [{
        instructor: test_instructor,
        location: 'Carrier Library Room 37',
        starts_at: '2014-12-11 14:00:00'
      }]
    },
    {
      section_number: '0002',
      seats: 25,
      parts_attributes: [{
        instructor: test_instructor,
        location: 'Rose Library Room 5308',
        starts_at: '2014-12-18 09:00:00'
      }]
    }
])

# Canvas 234: All Things Grading: Assignments, Assessments, Rubrics, and Speedgrader!
canvas234 = Course.create!(title: %{Canvas 234: All Things Grading: Assignments,
  Assessments, Rubrics, and Speedgrader!},
  course_number: 'CIT004',
  summary: %{Speedgrader? Speedgrader indeed! Come to this workshop and
leave on the fast track to grading.},
  description: %{Speedgrader? Speedgrader indeed! Come to this workshop and
leave on the fast track to grading.

# Objectives
At the completion of this workshop, you will be able to:

- Create various assessments
- Build a rubric for assessment
- Grade assignments with the speedgrader

# Recommended Prerequisites
- Canvas Orientation
- Canvas 101: The Philosophy},
  duration: 120)
canvas234.sections.create!([
    {
      section_number: '0001',
      seats: 25,
      parts_attributes: [{
        instructor: test_instructor,
        location: 'Carrier Library Room 37',
        starts_at: '2014-12-12 14:00:00'
      }]
    },
    {
      section_number: '0002',
      seats: 25,
      parts_attributes: [{
        instructor: test_instructor,
        location: 'Rose Library Room 5308',
        starts_at: '2014-12-19 09:00:00'
      }]
    }
])

# Canvas 235: Educating with Grading: Rubrics, Feedback, Group Work and Peer Review
canvas235 = Course.create!(title: %{Canvas 235: Educating with Grading: Rubrics, Feedback,
  Group Work and Peer Review},
  course_number: 'CIT005',
  summary: %{Many Canvas grading tools are available to inform students
and help improve their performance. Come learn about creating and using
rubrics, feedback, group assignments and peer review!},
  description: %{
> "Effective assessment is educative."
> - (Angelo & Cross, 1993; Wiggins, 1998)

Many Canvas grading tools are available to inform students
and help improve their performance. Come learn about creating and using
rubrics, feedback, group assignments and peer review!

# Objectives
At the completion of this workshop, you will be able to:

- Define features and types of a scoring rubric
- Develop a customized rubric for a class
- Provide feedback to students in Canvas
- Create a group assignment
- Create an assignment for peer review

# Recommended Prerequisites
- Canvas Orientation
- Canvas 101: The Philosophy
- Canvas 234: All Things Grading},
  duration: 180)

# Canvas Content Worksession
canvas_content_worksession = Course.create!(title: 'Canvas Content Worksession',
  course_number: 'CIT006',
  summary: %{Now that you have completed the Canvas Creating and Managing
Content workshop, meet one-on-one with a CIT representative to get some},
  description: %{Now that you have completed the Canvas Creating and Managing
Content workshop, meet one-on-one with a CIT representative to get some
help adding content to your course.},
  duration: 60)
canvas_content_worksession.sections.create!([
    {
      section_number: '0001',
      seats: 25,
      parts_attributes: [{
        instructor: test_instructor,
        location: 'Carrier Library Room 37',
        starts_at: '2014-12-10 15:15:00'
      }]
    },
    {
      section_number: '0002',
      seats: 25,
      parts_attributes: [{
        instructor: test_instructor,
        location: 'Rose Library Room 5308',
        starts_at: '2014-12-17 10:15:00'
      }]
    }
])
