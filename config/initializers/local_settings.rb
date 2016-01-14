# Loads local_settings.yml for site-specific configuration values
# Access these values via Rails.application.config.x["first-level"]["second-level"]

Rails.application.config.x = Rails.application.config_for(:local_settings);
