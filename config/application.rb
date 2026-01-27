# require 'dotenv/load' if ENV['RAILS_ENV'] == 'production'
# require 'dotenv/load'
require "dotenv/load" if ENV["RAILS_ENV"] == "development" || ENV["RAILS_ENV"] == "test" || ENV["RAILS_ENV"] == "production"

require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module EmbarkmentLtd
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    config.active_storage.variant_processor = :vips
    config.active_storage.replace_on_assign_to_many = false

    # File upload limits
    config.active_storage.routes_prefix = "/files"
   # Configuration for the application, engines, and railties goes here.
   #
   # These settings can be overridden in specific environments using the files
   # in config/environments, which are processed later.
   #
   # config.time_zone = "Central Time (US & Canada)"
   # config.eager_load_paths << Rails.root.join("extras")

   primary = ENV["ACTIVE_RECORD_ENCRYPTION_PRIMARY_KEY"]
    deterministic = ENV["ACTIVE_RECORD_ENCRYPTION_DETERMINISTIC_KEY"]
    salt = ENV["ACTIVE_RECORD_ENCRYPTION_KEY_DERIVATION_SALT"]

    if primary.present? && deterministic.present? && salt.present?
      if [ primary, deterministic, salt ].all? { |k| k.match?(/\A[0-9a-f]+\z/i) }
        config.active_record.encryption.primary_key = [ primary ].pack("H*")
        config.active_record.encryption.deterministic_key = [ deterministic ].pack("H*")
        config.active_record.encryption.key_derivation_salt = [ salt ].pack("H*")
      end
    end
  end
end
