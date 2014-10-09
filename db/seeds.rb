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
Section.create!([
    {
      location: 'Carrier Library Room 37',
      starts_at: '2014-12-09 14:00:00',
      seats: 25,
      course: canvas101
    },
    {
      location: 'Rose Library Room 5308',
      starts_at: '2014-12-16 09:00:00',
      seats: 25,
      course: canvas101
    },
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
Section.create!([
    {
      location: 'Carrier Library Room 37',
      starts_at: '2014-12-10 14:00:00',
      seats: 25,
      course: canvas113
    },
    {
      location: 'Rose Library Room 5308',
      starts_at: '2014-12-17 09:00:00',
      seats: 25,
      course: canvas113
    },
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
Section.create!([
    {
      location: 'Carrier Library Room 37',
      starts_at: '2014-12-11 14:00:00',
      seats: 25,
      course: canvas211
    },
    {
      location: 'Rose Library Room 5308',
      starts_at: '2014-12-18 09:00:00',
      seats: 25,
      course: canvas211
    },
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
Section.create!([
    {
      location: 'Carrier Library Room 37',
      starts_at: '2014-12-12 14:00:00',
      seats: 25,
      course: canvas234
    },
    {
      location: 'Rose Library Room 5308',
      starts_at: '2014-12-19 09:00:00',
      seats: 25,
      course: canvas234
    },
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

Section.create!([
    {
      location: 'Carrier Library Room 37',
      starts_at: '2014-12-10 15:15:00',
      seats: 25,
      course: canvas_content_worksession
    },
    {
      location: 'Rose Library Room 5308',
      starts_at: '2014-12-17 10:15:00',
      seats: 25,
      course: canvas_content_worksession
    },
])

# Set developer accounts as admins and create test users that locally authenticate
User.create!([
  {
    username: 'shortjw',
    role: 2,
  },
  {
    username: 'shanklt',
    role: 2,
  },
  {
    username: 'admin',
    encrypted_password: '$2a$10$yh37UU21ksjRwF56K2vE6enfjveXxbgmX7JXNH6P9X7TODadBOBz2', # testadmin
    role: 2,
  },
  {
    username: 'instructor',
    encrypted_password: '$2a$10$1sLJQ176FlCZzJOktW6dA.PJoNvjwfd5yDKA5jOCeGm9ILY0GU1PC', # testinstructor
    role: 1,
  },
  {
    username: 'user',
    encrypted_password: '$2a$10$wPHMVeU5uj.OTUKI4yIgwO6eBSUYsf6M5VGA8l2sLpaEu0PzSwzB.', # testuser
    role: 0,
  },
 ])

