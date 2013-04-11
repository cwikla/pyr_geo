module Tgp
  module Geo
    class Engine < ::Rails::Engine
      config.tgp_geo_precision = :half_mile
    end
  end
end
