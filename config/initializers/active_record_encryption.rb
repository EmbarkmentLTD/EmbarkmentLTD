# Rails.application.config.active_record.encryption.tap do |config|
#   config.primary_key = [ENV.fetch("ACTIVE_RECORD_ENCRYPTION_PRIMARY_KEY")].pack("H*")
#   config.deterministic_key = [ENV.fetch("ACTIVE_RECORD_ENCRYPTION_DETERMINISTIC_KEY")].pack("H*")
#   config.key_derivation_salt = [ENV.fetch("ACTIVE_RECORD_ENCRYPTION_KEY_DERIVATION_SALT")].pack("H*")
# end

if ENV["ACTIVE_RECORD_ENCRYPTION_PRIMARY_KEY"].present?
  Rails.application.config.active_record.encryption.tap do |config|
    config.primary_key = [ENV["ACTIVE_RECORD_ENCRYPTION_PRIMARY_KEY"]].pack("H*")
    config.deterministic_key = [ENV["ACTIVE_RECORD_ENCRYPTION_DETERMINISTIC_KEY"]].pack("H*")
    config.key_derivation_salt = [ENV["ACTIVE_RECORD_ENCRYPTION_KEY_DERIVATION_SALT"]].pack("H*")
  end
end
