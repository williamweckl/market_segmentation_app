ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/autorun'
require 'minitest/reporters'
require 'pp'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Minitest helpers
  extend MiniTest::Spec::DSL
  reporter_options = {color: true, slow_count: 5}
  Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(reporter_options)]

  ActiveJob::Base.queue_adapter = :test
end