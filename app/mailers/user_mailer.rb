class UserMailer < ActionMailer::Base
  default from: "no-reply@jmu.edu"

  def enroll_email(user, section)
  	@user = user
  	@course = section.course.title
  	@starts_at = section.starts_at
  	mail(to: @user.email, subject: "Enrollment: #{@course}")
  end
end
