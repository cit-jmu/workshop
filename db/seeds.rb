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

# Canvas 101: The Philosophy
canvas101 = Course.create!(title: 'Canvas 101: The Philosophy',
  description: %{Canvas IS different! In this one hour session, you will
    develop a roadmap for designing your course in a way that benefits you AND
    your students.},
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
  description: %{Do you have course content files that need to make their way
    into Canvas? In this session you will add and organize content in your
    course.},
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
  description: %{Explore the many avenues for interaction and communication:
    instructor-student, student-student, and student-content.},
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
  description: %{Speedgrader? Speedgrader indeed! Come to this workshop and
    leave on the fast track to grading.},
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
  description: %{Effective assessment is educative (Angelo & Cross, 1993;
    Wiggins, 1998). Many Canvas grading tools are available to inform students
    and help improve their performance. Come learn about creating and using
    rubrics, feedback, group assignments and peer review!},
  instructor: 'Elaine Roberts Kaye',
  duration: 180)

# Canvas Content Worksession
canvas_content_worksession = Course.create!(title: 'Canvas Content Worksession',
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
