require "tgp_geo/engine"

module TgpGeo

  def self.config(&block)
    yield Engine.config if block
    Engine.config
  end
end
