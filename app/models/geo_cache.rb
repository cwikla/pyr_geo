class GeoCache < ActiveRecord::Base
  include GeoRecord
  acts_as_simple_cache

  before_save :shorten_lat_lng

  def self.reverse_geocode_from_lat_long(latitude, longitude)
    latitude = latitude.to_f
    longitude = longitude.to_f

    return nil if latitude.to_i == 0

    geo_cache = self.fetch(latitude, longitude)

    #puts "GEO_CACHE #{geo_cache.inspect}"

    #return geo_cache

    if geo_cache.nil?

      puts "REVERSE GEOCODING #{latitude}/#{longitude}"
      geo = Geo::reverse_geocode_from_lat_long(latitude, longitude)
      if geo && geo.latitude && geo.longitude
        geo_cache = GeoCache.new
        geo_cache.geo = geo
        geo_cache = geo_cache.save_unique_or_retry {
          GeoCache.fetch(latitude, longitude)
        }
        self.stash(geo_cache, latitude, longitude)
      end

    end

    if !geo_cache.nil? # put back the originals in case they got shortened
      geo_cache.latitude = latitude
      geo_cache.longitude = longitude
    end

    geo_cache.readonly! if geo_cache


    return geo_cache

  end

  def update_geo
    # do nothing here
  end

  def self.safe(l)
    l = l.to_f
    "%0.2f" % l
  end

  def self.make_key(latitude, longitude)
    dlat = latitude.to_f
    dlng = longitude.to_f

    return nil if dlat.to_i == 0

    return "#{safe(dlat)}/#{safe(dlng)}"
  end

  def self.fetch(latitude, longitude)
    key = self.make_key(latitude, longitude)
    return nil if key.nil?

    GeoCache.cache_fetch(key) {
      puts "GETTING FROM CACHE #{key}"
      dlat = safe(latitude)
      dlng = safe(longitude)
      GeoCache.where(:latitude => dlat, :longitude => dlng).first
    }
  end

  def self.stash(geo_cache, latitude, longitude)
    key = self.make_key(latitude, longitude)
    return nil if key.nil?

    GeoCache.cache_write(key, geo_cache)
  end

  def shorten_lat_lng
    #puts "SHORTENING"
    self.latitude = GeoCache.safe(self.latitude) if self.latitude
    self.longitude = GeoCache.safe(self.longitude) if self.longitude
  end

end
