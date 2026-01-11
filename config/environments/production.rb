require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.


  config.require_master_key = false  # Temporarily disable for testing

config.secret_key_base = ENV['SECRET_KEY_BASE'] || 'development_secret_key_placeholder_#{SecureRandom.hex(64)}'

  # Code is not reloaded between requests.
  config.enable_reloading = false

  # Eager load code on boot for better performance and memory savings (ignored by Rake tasks).
  config.eager_load = true

  # Full error reports are disabled.
  config.consider_all_requests_local = false

  # Turn on fragment caching in view templates.
  config.action_controller.perform_caching = true

  # Cache assets for far-future expiry since they are all digest stamped.
  config.public_file_server.headers = { "cache-control" => "public, max-age=#{1.year.to_i}" }

  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
  # config.asset_host = "http://assets.example.com"

  # Store uploaded files on the local file system (see config/storage.yml for options).
  config.active_storage.service = :local

  # Assume all access to the app is happening through a SSL-terminating reverse proxy.
  #config.assume_ssl = true

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  #config.force_ssl = true

  # Skip http-to-https redirect for the default health check endpoint.
  # config.ssl_options = { redirect: { exclude: ->(request) { request.path == "/up" } } }

  # Log to STDOUT with the current request id as a default log tag.
  config.log_tags = [ :request_id ]
  config.logger   = ActiveSupport::TaggedLogging.logger(STDOUT)

  # Change to "debug" to log everything (including potentially personally-identifiable information!)
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")

  # Prevent health checks from clogging up the logs.
  config.silence_healthcheck_path = "/up"

  # Don't log any deprecations.
  config.active_support.report_deprecations = false

  # Replace the default in-process memory cache store with a durable alternative.
  config.cache_store = :solid_cache_store

  # Replace the default in-process and non-durable queuing backend for Active Job.
  config.active_job.queue_adapter = :solid_queue # :inline 
  config.solid_queue.connects_to = { database: { writing: :queue } }



  # Ignore bad email addresses and do not raise email delivery errors.
  # Set this to true and configure the email server for immediate delivery to raise delivery errors.
  # EMAIL CONFIGURATION - GO DADDY SMTP
  # ====================================
  
  # Enable email delivery
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = false
  
  # Use SMTP delivery (not sendgrid_actionmailer)
  config.action_mailer.delivery_method = :smtp
  
  # GoDaddy SMTP Settings - Port 587 with STARTTLS
  config.action_mailer.smtp_settings = {
    # Server address
    address: 'smtpout.secureserver.net',
    
    # Port 587 for STARTTLS (recommended)
    port: 587,
    
    # Your GoDaddy domain
    domain: 'llw-cs.com',
    
    # Your GoDaddy email credentials
    user_name: 'company@llw-cs.com',
    password: 'Consultancy25$',
    
    # Authentication type (GoDaddy uses PLAIN)
    authentication: :plain,
    
    # Enable STARTTLS for secure connection
    enable_starttls_auto: true,
    
    # Timeout settings
    open_timeout: 30,
    read_timeout: 30,
    
    # Optional: Disable SSL certificate verification if needed
    openssl_verify_mode: 'none'
  }
  
  # Default email headers
  config.action_mailer.default_options = {
    from: 'EmbarkmentLTD <company@llw-cs.com>',
    reply_to: 'company@llw-cs.com'
  }
  
  # URL options for links in emails
  config.action_mailer.default_url_options = {
    host: 'llw-cs.com',
    protocol: 'https'
  }


#   # Specify outgoing SMTP server. Remember to add smtp/* credentials via rails credentials:edit.
#   config.action_mailer.delivery_method = :sendgrid_actionmailer

#   config.action_mailer.default_options = {
#   from: 'EmbarkmentLTD <company@llw-cs.com>',
#   reply_to: 'company@llw-cs.com'
# }

# config.action_mailer.default_url_options = {
#   host: 'llw-cs.com',
#   protocol: 'https'
# }

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation cannot be found).
  config.i18n.fallbacks = true

  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false

  # Only use :id for inspections in production.
  config.active_record.attributes_for_inspect = [ :id ]

  # Enable DNS rebinding protection and other `Host` header attacks.
  # config.hosts = [
  #   "example.com",     # Allow requests from example.com
  #   /.*\.example\.com/ # Allow requests from subdomains like `www.example.com`
  # ]
  #
  # Skip DNS rebinding protection for the default health check endpoint.
  # config.host_authorization = { exclude: ->(request) { request.path == "/up" } }
end
