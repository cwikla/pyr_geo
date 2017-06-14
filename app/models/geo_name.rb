class GeoName < ApplicationRecord
  include Pyr::Geo::Model::Name

  def self.search(val, maxCount=50)
    likeVal = "#{val}%"
    where("name ilike ?", likeVal).limit(maxCount)
  end
end
