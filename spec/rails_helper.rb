# frozen_string_literal: true
require 'coveralls'
Coveralls.wear!('rails')
# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
# Add additional requires below this line. Rails is not loaded until this point!
require 'database_cleaner'
require 'active_fedora/cleaner'
require 'hyrax/spec/factory_bot/build_strategies'
require 'hyrax/spec/matchers'
require 'hyrax/spec/shared_examples'
require 'webmock/rspec'

# Support the old FactoryGirl name for the moment, use `FactoryBot` going
# forward.
FactoryGirl = FactoryBot unless defined?(FactoryGirl)

Dir[Rails.root.join('spec', 'support', '**', '*.rb')].each { |f| require f }

# Remove a deprecated FactoryBot feature that causes problems for doubles
FactoryBot.allow_class_lookup = false

# Checks for pending migration and applies them before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")

  config.include FactoryBot::Syntax::Methods

  config.before(:suite) do
    # Enable web connections; disable explictly for certain example groups
    WebMock.allow_net_connect!

    ActiveJob::Base.queue_adapter = :test
    ActiveFedora::Cleaner.clean!
    DatabaseCleaner.clean_with(:truncation)
    AdminSet.find_or_create_default_admin_set_id
  end

  config.include(ControllerLevelHelpers, type: :view)
  config.before(type: :view) { initialize_controller_helpers(view) }

  config.before(datacite_api: true) do
    @datacite_requests = {}

    if Datacite::Configuration.instance.password.match?(/PASSWORD/)
      WebMock.disable_net_connect!(allow_localhost: true)

      # give 401 on all credentials
      @datacite_requests[:post_bad_credentials] =
        stub_request(:post, "https://mds.test.datacite.org/metadata")
        .with(headers: { 'Content-Type' => 'application/xml' })
        .to_return(status: 401, body: 'Unauthorized', headers: {})

      # give 201 for configured credentials; any configured credentials will do
      @datacite_requests[:post_create] =
        stub_request(:post, "https://mds.test.datacite.org/metadata")
        .with(headers:    { 'Content-Type' => 'application/xml' },
              basic_auth: [Datacite::Configuration.instance.login,
                           Datacite::Configuration.instance.password])
        .to_return(status: 201, body: 'Yay!', headers: {})

      # 404 when auth is good on an unrecognized path
      @datacite_requests[:get_404] =
        stub_request(:get, /https:\/\/mds\.test\.datacite\.org\/metadata\/#{Datacite::Configuration.instance.prefix}\/.*/)
        .with(basic_auth: [Datacite::Configuration.instance.login,
                           Datacite::Configuration.instance.password])
        .to_return(status: 404)

      # 200 when the path is expected
      @datacite_requests[:get] =
        stub_request(:get, "https://mds.test.datacite.org/metadata/#{Datacite::Configuration.instance.prefix}/moomin")
        .with(basic_auth: [Datacite::Configuration.instance.login,
                           Datacite::Configuration.instance.password])
        .to_return(status:  200,
                   body:    "<?xml version=\"1.0\"?>\n<resource xmlns=\"" \
                   "http://datacite.org/schema/kernel-4\" xmlns:xsi=\"" \
                   "http://www.w3.org/2001/XMLSchema-instance\" " \
                   "xsi:schemaLocation=\"http://datacite.org/schema/kernel-4 " \
                   "http://schema.datacite.org/meta/kernel-4/metadata.xsd\">\n  " \
                   "<identifier identifierType=\"DOI\">10.5072/moomin</identifier>\n  " \
                   "<titles>\n    <title>Comet in Moominland</title>\n  </titles>\n  " \
                   "<creators>\n    <creator>\n      <creatorName>:unav</creatorName>\n    " \
                   "</creator>\n  </creators>\n  <publisher>:unav</publisher>\n  " \
                   "<publicationYear>2017</publicationYear>\n  " \
                   "<resourceType resourceTypeGeneral=\"Text\">Dissertation</resourceType>\n  " \
                   "<version>4.0</version>\n</resource>\n",
                   headers: {})
    end
  end

  config.after(datacite_api: true) do
    @datacite_requests.each_value { |stub| remove_request_stub(stub) }
    WebMock.allow_net_connect!
  end

  # Use this example group when you want to perform jobs inline during testing.
  #
  # Limit to specific job classes with:
  #
  #   ActiveJob::Base.queue_adapter.filter = [JobClass]
  config.before(perform_enqueued: true) do
    ActiveJob::Base.queue_adapter.perform_enqueued_jobs    = true
    ActiveJob::Base.queue_adapter.perform_enqueued_at_jobs = true
  end

  config.after(perform_enqueued: true) do
    ActiveJob::Base.queue_adapter.enqueued_jobs  = []
    ActiveJob::Base.queue_adapter.performed_jobs = []

    ActiveJob::Base.queue_adapter.perform_enqueued_jobs    = false
    ActiveJob::Base.queue_adapter.perform_enqueued_at_jobs = false
  end
end
