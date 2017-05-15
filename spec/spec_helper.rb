ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../test_app/config/environment.rb",  __FILE__)

require 'rspec/rails'
require 'factory_girl'
require 'capybara'

ENGINE_RAILS_ROOT=File.join(File.dirname(__FILE__), '../')


Dir[File.join(ENGINE_RAILS_ROOT, "spec/support/**/*.rb")].each {|f| require f }


RSpec.configure do |config|

  config.include FactoryGirl::Syntax::Methods

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

end
