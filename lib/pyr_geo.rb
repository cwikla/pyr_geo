require 'pyr/geo/engine'
require 'pyr/geo/util/coder'
require 'pyr/geo/util/loader'
require 'pyr/geo/model/geo'
require 'pyr/geo/model/cache'
require 'pyr/geo/model/name'
require 'pyr/geo/model/city'
require 'pyr/geo/version'

module Pyr
  module Geo

    def self.config(&block)
      yield Engine.config if block
      Engine.config
    end
  end
end

