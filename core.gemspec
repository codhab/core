$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "core/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "core"
  s.version     = Core::VERSION
  s.authors     = ["Elton Silva"]
  s.email       = ["elton.chrls@gmail.com"]
  s.homepage    = "https://github.com/codhab/core.git"
  s.summary     = "Summary of Core."
  s.description = "Description of Core."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/***/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["spec/***/**/*"]

  s.add_dependency "rails", "~> 5.0.2"
  s.add_dependency "pg"
  s.add_dependency "one_signal"
  s.add_dependency "validates_cpf_cnpj"
  s.add_dependency "validates_timeliness"
  s.add_dependency "email_validator"
  s.add_dependency "file_validators"
  s.add_dependency "carrierwave"
  s.add_dependency "friendly_id"
  s.add_dependency "haml-rails"

end
