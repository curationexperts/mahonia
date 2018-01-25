# frozen_string_literal: true
class AuthConfig
  # In production, we use Shibboleth for user authentication,
  # but in development mode, you may want to use local database
  # authentication instead.
  # Always use database mode in test environment, otherwise password
  # methods aren't available.
  def self.use_database_auth?
    return true if Rails.env.test?
    Rails.env.development? && ENV['DATABASE_AUTH'] == 'true'
  end
end
