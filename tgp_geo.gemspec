$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "tgp_geo/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "tgp_geo"
  s.version     = TgpGeo::VERSION
  s.authors     = ["The Giant Pixel"]
  s.email       = ["extapi@thegiantpixel.com"]
  #s.homepage    = ["http://www.thegiantpixel.com"]
  s.summary     = ["Geographic support library"]
  s.description = ["Geographic support library"]

  s.files = Dir["{app,config,db,lib}/**/*"] + ["Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency 'geocoder', '>= 1.1.6'

  # s.add_dependency "jquery-rails"
end
