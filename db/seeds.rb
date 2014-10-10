# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Clear out existing data
Section.delete_all
Course.delete_all
User.delete_all

# Canvas 101: The Philosophy
canvas101 = Course.create!(title: 'Canvas 101: The Philosophy',
  summary: %{Canvas ***IS*** different! In this one hour session, you will
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
  instructor: 'Nicole Wilson',
  duration: 60)
canvas101.sections.create!([
    {
      location: 'Carrier Library Room 37',
      starts_at: '2014-12-09 14:00:00',
      seats: 25
    },
    {
      location: 'Rose Library Room 5308',
      starts_at: '2014-12-16 09:00:00',
      seats: 25
    }
])

# Canvas 113: Creating and Managing Content
canvas113 = Course.create!(title: 'Canvas 113: Creating and Managing Content',
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
  instructor: 'Dave Stoops',
  duration: 60)
canvas113.sections.create!([
    {
      location: 'Carrier Library Room 37',
      starts_at: '2014-12-10 14:00:00',
      seats: 25
    },
    {
      location: 'Rose Library Room 5308',
      starts_at: '2014-12-17 09:00:00',
      seats: 25
    }
])

# Canvas 211: Communication
canvas211 = Course.create!(title: 'Canvas 211: Communication',
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
  instructor: 'Elaine Roberts',
  duration: 60)
canvas211.sections.create!([
    {
      location: 'Carrier Library Room 37',
      starts_at: '2014-12-11 14:00:00',
      seats: 25
    },
    {
      location: 'Rose Library Room 5308',
      starts_at: '2014-12-18 09:00:00',
      seats: 25
    }
])

# Canvas 234: All Things Grading: Assignments, Assessments, Rubrics, and Speedgrader!
canvas234 = Course.create!(title: %{Canvas 234: All Things Grading: Assignments,
  Assessments, Rubrics, and Speedgrader!},
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
  instructor: 'Christie Liu',
  duration: 120)
canvas234.sections.create!([
    {
      location: 'Carrier Library Room 37',
      starts_at: '2014-12-12 14:00:00',
      seats: 25
    },
    {
      location: 'Rose Library Room 5308',
      starts_at: '2014-12-19 09:00:00',
      seats: 25
    }
])

# Canvas 235: Educating with Grading: Rubrics, Feedback, Group Work and Peer Review
canvas235 = Course.create!(title: %{Canvas 235: Educating with Grading: Rubrics, Feedback,
  Group Work and Peer Review},
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
  instructor: 'Elaine Roberts Kaye',
  duration: 180)

# Canvas Content Worksession
canvas_content_worksession = Course.create!(title: 'Canvas Content Worksession',
  summary: %{Now that you have completed the Canvas Creating and Managing
Content workshop, meet one-on-one with a CIT representative to get some},
  description: %{Now that you have completed the Canvas Creating and Managing
Content workshop, meet one-on-one with a CIT representative to get some
help adding content to your course.},
  instructor: 'CIT Faculty Development',
  duration: 60)
canvas_content_worksession.sections.create!([
    {
      location: 'Carrier Library Room 37',
      starts_at: '2014-12-10 15:15:00',
      seats: 25
    },
    {
      location: 'Rose Library Room 5308',
      starts_at: '2014-12-17 10:15:00',
      seats: 25
    }
])

# Set developer accounts as admins and create test users that locally authenticate
User.create!([
  {
    username: 'shortjw',
    role: :admin
  },
  {
    username: 'shanklt',
    role: :admin
  },
  {
    username: 'admin',
    first_name: 'Test',
    last_name: 'Admin',
    email: 'test-admin@example.org',
    password: 'testadmin',
    password_confirmation: 'testadmin',
    role: :admin
  },
  {
    username: 'instructor',
    first_name: 'Test',
    last_name: 'Instructor',
    email: 'test-instructor@example.org',
    password: 'testinstructor',
    password_confirmation: 'testinstructor',
    role: :instructor
  },
  {
    username: 'user',
    first_name: 'Test',
    last_name: 'User',
    email: 'test-user@example.org',
    password: 'testuser',
    password_confirmation: 'testuser',
    role: :user
  }
 ])
