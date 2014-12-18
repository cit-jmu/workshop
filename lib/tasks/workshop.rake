namespace :workshop do
  desc "Sends reminder emails to users enrolled in sections starting tomorrow"
  task :send_reminders do
    Part.starting_tomorrow.each do |part|
      part.section.enrollments.each { |e| e.send_reminder }
    end
  end
end
