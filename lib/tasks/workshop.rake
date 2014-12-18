namespace :workshop do
  desc "Sends reminder emails to users enrolled in sections starting soon"
  task :send_reminders => :environment do
    Part.starting_soon.each do |part|
      part.section.enrollments.each { |e| e.send_reminder }
    end
  end
end
