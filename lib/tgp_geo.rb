require "tgp/geo/engine"

require 'tgp/geo/geo'
require 'tgp/geo/model/geo_record'

module Tgp
  module Geo

    def self.config(&block)
      yield Engine.config if block
      Engine.config
    end
  end
end

