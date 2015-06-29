$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "find_helper/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "find_helper"
  s.version     = FindHelper::VERSION
  s.authors     = ["panaoke"]
  s.email       = ["panaoke@gmail.com"]
  s.homepage    = "https://github.com/panaoke/find_helper"
  s.summary     = "active record or mongoid find helper"
  s.description = "make orm model find so easy"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

end
