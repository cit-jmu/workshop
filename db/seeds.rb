# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Course.delete_all
# Canvas 101: The Philosophy
Course.create!(title: 'Canvas 101: The Philosophy',
  description: %{Canvas IS different! In this one hour session, you will
    develop a roadmap for designing your course in a way that benefits you AND
    your students.},
  instructor: 'Nicole Wilson',
  duration: 60)
# Canvas 113: Creating and Managing Content
Course.create!(title: 'Canvas 113: Creating and Managing Content',
  description: %{Do you have course content files that need to make their way
    into Canvas? In this session you will add and organize content in your
    course.},
  instructor: 'Dave Stoops',
  duration: 60)
# Canvas 211: Communication
Course.create!(title: 'Canvas 211: Communication',
  description: %{Explore the many avenues for interaction and communication:
    instructor-student, student-student, and student-content.},
  instructor: 'Elaine Roberts',
  duration: 60)
# Canvas 234: All Things Grading: Assignments, Assessments, Rubrics, and Speedgrader!
Course.create!(title: %{Canvas 234: All Things Grading: Assignments,
  Assessments, Rubrics, and Speedgrader!},
  description: %{Speedgrader? Speedgrader indeed! Come to this workshop and
    leave on the fast track to grading.},
  instructor: 'Christie Liu',
  duration: 120)
# Canvas 235: Educating with Grading: Rubrics, Feedback, Group Work and Peer Review
Course.create!(title: %{Canvas 235: Educating with Grading: Rubrics, Feedback,
  Group Work and Peer Review},
  description: %{Effective assessment is educative (Angelo & Cross, 1993;
    Wiggins, 1998). Many Canvas grading tools are available to inform students
    and help improve their performance. Come learn about creating and using
    rubrics, feedback, group assignments and peer review!},
  instructor: 'Elaine Roberts Kaye',
  duration: 180)
# Canvas Content Worksession
Course.create!(title: 'Canvas Content Worksession',
  description: %{Now that you have completed the Canvas Creating and Managing
    Content workshop, meet one-on-one with a CIT representative to get some
    help adding content to your course.},
  instructor: 'CIT Faculty Development',
  duration: 60)
