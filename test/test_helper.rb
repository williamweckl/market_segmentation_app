ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/autorun'
require 'minitest/reporters'
require 'capybara/rails'
require 'support/billy'
require 'pp'

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  self.use_transactional_tests = false

  # Minitest helpers
  extend MiniTest::Spec::DSL
  reporter_options = {color: true, slow_count: 5}
  Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(reporter_options)]

  ActiveJob::Base.queue_adapter = :test

  Capybara.ignore_hidden_elements = true
  Capybara.current_driver = Capybara.javascript_driver
end

ActionController::TestCase.class_eval do
  include RequestTestHelpers
end

class ActionDispatch::IntegrationTest
  # Make the Capybara DSL available in all integration tests
  include Capybara::DSL
  include Billy::MinitestHelper
end