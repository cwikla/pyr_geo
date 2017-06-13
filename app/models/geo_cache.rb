class GeoName < ApplicationRecord
  include Pyr::Geo::Model::Cache
end
