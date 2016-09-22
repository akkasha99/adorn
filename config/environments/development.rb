Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  require 'tlsmail'
  Net::SMTP.enable_tls(OpenSSL::SSL::VERIFY_NONE)

  ActionMailer::Base.delivery_method = :smtp
  config.action_mailer.perform_deliveries = true
  config.action_mailer.default :charset => "utf-8"
  ActionMailer::Base.smtp_settings = {
      :address => "smtp.mandrillapp.com",
      :port => 587,
      :user_name => "inc.adoorn@gmail.com",
      :password => 'Rf5Duc4XpNMryYukKBadng',
      :authentication => "plain",
      :enable_starttls_auto => true
  }

  # Show full error reports and disable caching.
  config.consider_all_requests_local = true
  config.action_controller.perform_caching = false
  config.action_mailer.perform_deliveries = false

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  #config.action_mailer.default_url_options = {host: 'localhost', port: 3000}
  config.action_mailer.default_url_options = {:host => 'localhost:3000'}
  Rails.application.routes.default_url_options[:host] = 'localhost:3000'

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true
  config.assets.compress = false

  TWITTER_KEY = 'sEyK42ov4duWUCWnrwIwoqLqz'
  TWITTER_SECRET = 'A0DigfZqTmPRVUaO34RqxFXY5DFj0ET7eF9QVhZtDoMMZc2T2v'
  TUMBLR_KEY = 'skT1ExukL4jR2kZJ197mMxy1QE9lyXFEIqFNIhKKASWnG3xHZ2'
  TUMBLR_SECRET = 'VWRdtOHMaq3l9ut4ov5egdJVvXMYETQ1Q4oYdP5oyfiTAw0hDM'
end
