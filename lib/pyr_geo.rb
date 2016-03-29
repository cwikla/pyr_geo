require "pyr/geo/engine"

require 'pyr/geo/geo'
require 'pyr/geo/model/geo_record'
require 'pyr/geo/version'

module Pyr
  module Geo

    def self.config(&block)
      yield Engine.config if block
      Engine.config
    end
  end
end

