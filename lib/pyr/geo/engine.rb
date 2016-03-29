module Pyr
  module Geo
    class Engine < ::Rails::Engine
      config.pyr_geo_precision = :half_mile
    end
  end
end
