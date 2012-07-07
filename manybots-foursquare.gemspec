$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "manybots-foursquare/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "manybots-foursquare"
  s.version     = ManybotsFoursquare::VERSION
  s.authors     = ["Alex L. Solleiro"]
  s.email       = ["alex@webcracy.org"]
  s.homepage    = "http://github.com/manybots/manybots-foursquare"
  s.summary     = "Import your checkins to your Manybots account."
  s.description = "This Manybots Observer allows you to connect to Foursquare and import checkins to your account."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.3"
  s.add_dependency "oauth2"
  s.add_dependency "foursquare2"

  s.add_development_dependency "sqlite3"
end
