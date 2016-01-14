# Loads local_settings.yml for site-specific configuration values
# Access these values via Rails.application.config.x["first-level"]["second-level"]
local_defaults = {
  identity: {
    site_name: "My Workshops",
    site_owner: "Workshop Site Owner",
    replyto: "email@yourdomain.com",
    site_owner_link: "http://mydomain.com",
    site_owner_link_text: "My Home Page"
  },
  terminology: {
    course: 'Course',
    instructor: 'Instructor',
    workshop: 'Workshop',
    section: 'Section'
  }
}

if File.exist?(File.join("config", "local_settings.yml"))
  Rails.application.config.x = Rails.application.config_for(:local_settings);
else
  Rails.application.config.x = local_defaults
end
