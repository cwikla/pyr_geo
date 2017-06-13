$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "pyr/geo/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "pyr_geo"
  s.version     = Pyr::Geo::VERSION
  s.authors     = ["John Cwikla"]
  s.email       = ["gems@cwikla.com"]
  s.homepage    = "http://www.cwikla.com"
  s.summary     = "Geographic support library"
  s.description = "Geographic support library Description"
  s.post_install_message = "You can lead a horse to water, but you can't teach it to fish"

  s.files = Dir["{app,config,db,lib,data}/**/*"] + ["Rakefile"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", ">= 5.0.0"

  s.add_dependency 'geocoder', ">= 1.3.1"
end
