class GeoCity < ApplicationRecord
  include Pyr::Geo::Model::City

  def self.search(val, maxCount=50)
    likeVal = "#{val}%"
    where(:iso_country => "US").where("latitude is not null").where("city ilike ?", likeVal).order("population desc").limit(maxCount)
  end
end
