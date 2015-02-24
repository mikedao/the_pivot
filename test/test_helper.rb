require "simplecov"
SimpleCov.start do
  add_filter "/factories/"
end

Dir[Rails.root.join("test/support/**/*.rb")].each { |f| require f }

ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../../config/environment', __FILE__)
require "rails/test_help"
require "capybara/rails"
require "mocha/mini_test"
require "minitest/pride"
require "factory_girl_rails"
require "support/factory_girl"
require "database_cleaner"
require "date"

DatabaseCleaner.strategy = :transaction

class ActiveSupport::TestCase
  include FactoryGirl::Syntax::Methods
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def setup
    DatabaseCleaner.start
    FactoryGirl.reload
  end

  def teardown
    DatabaseCleaner.clean
  end
end

class ActionDispatch::IntegrationTest
  include FactoryGirl::Syntax::Methods
  include TestHelperMethods

  def setup
    DatabaseCleaner.start
  end

  def teardown
    reset_session!
    DatabaseCleaner.clean
  end

  Capybara.javascript_driver = :webkit
end
