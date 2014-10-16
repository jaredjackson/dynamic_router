require 'coveralls'
Coveralls.wear!

require "codeclimate-test-reporter"
CodeClimate::TestReporter.start


# Configure Rails Envinronment
ENV["RAILS_ENV"] = "test"

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require 'pry'
require 'dynamic_router'

ActionMailer::Base.delivery_method = :test
ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.default_url_options[:host] = "test.com"

Rails.backtrace_cleaner.remove_silencers!

ActiveRecord::Base.establish_connection :adapter=>"sqlite3", :database => ":memory:"
require File.dirname(__FILE__) + "/db/create_database"

CreateDatabase.migrate(:up)

# Run any available migration
ActiveRecord::Migrator.migrate File.expand_path("../dummy/db/migrate/", __FILE__)

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.mock_with :rspec
  config.include ActionView::Helpers
end