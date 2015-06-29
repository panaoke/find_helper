$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "find_helper/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "find_helper"
  s.version     = FindHelper::VERSION
  s.authors     = ["panaoke"]
  s.email       = ["panaoke@gmail.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of FindHelper."
  s.description = "TODO: Description of FindHelper."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.1.6"

  s.add_development_dependency "sqlite3"
end
