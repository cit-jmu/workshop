namespace :workshop do
  desc "Sends reminder emails to users enrolled in sections starting soon"
  task :send_reminders => :environment do
    puts "[#{DateTime.current}] rake task workshop:send_reminders starting"
    Part.starting_soon.each do |part|
      part.section.enrollments.each do |e|
        e.send_reminder
        puts "  Reminder sent to #{e.user.email} for #{e.section.course.short_title}" 
      end
    end
  end
end
