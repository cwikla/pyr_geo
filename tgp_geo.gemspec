$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "tgp/geo/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "tgp_geo"
  s.version     = Tgp::Geo::VERSION
  s.authors     = ["The Giant Pixel"]
  s.email       = ["extapi@thegiantpixel.com"]
  s.homepage    = "http://www.thegiantpixel.com"
  s.summary     = "Geographic support library"
  s.description = "Geographic support library Description"
  s.post_install_message = "You can lead a horse to water, but you can't make it fish"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["Rakefile"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency 'geocoder', '>= 1.1.6'

  # s.add_dependency "jquery-rails"
end
