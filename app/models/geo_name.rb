class GeoName < ApplicationRecord
  include Pyr::Geo::Model::Name

  def self.search(val, maxCount=50)
    likeVal = "#{val}%"
    where(:iso_country => "US").where("cluster_latitude is not null").where("name ilike ?", likeVal).limit(maxCount)
  end
end
