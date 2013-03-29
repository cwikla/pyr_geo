require "tgp_geo/engine"

module TgpGeo

  def self.config(&block)
    yield Engine.config if block
    Engine.config
  end
end

require 'tgp_geo/geo'
require 'tgp_geo/geo_record'
