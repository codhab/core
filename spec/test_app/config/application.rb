require_relative 'boot'

# Pick the frameworks you want:
require "active_record/railtie"
require "action_controller/railtie"
require "action_view/railtie"
require "action_mailer/railtie"
require "active_job/railtie"
require "action_cable/engine"
# require "rails/test_unit/railtie"
require "sprockets/railtie"

Bundler.require(*Rails.groups)
require "core"

rails_root = Pathname.new('..').expand_path(File.dirname(__FILE__))

begin
  APP_ENV = YAML.load_file("#{rails_root}/config/env.yml")
rescue
  if Rails.env.development? || Rails.env.test?
    raise ArgumentError, 'Need to configure config/env.yml'
  end
end


module TestApp
  class Application < Rails::Application
  end
end

