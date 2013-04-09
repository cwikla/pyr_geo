require "tgp_geo/engine"

require 'tgp_geo/geo'
require 'tgp_geo/model/geo_record'

module TgpGeo

  def self.config(&block)
    yield Engine.config if block
    Engine.config
  end
end

