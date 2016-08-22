

module Pyr::Geo
  class GeoCache < ActiveRecord::Base
    include Pyr::Geo::Model::Geo
  
    acts_as_simple_cache
  
    #before_save :shorten_lat_lng
  
    # roughly speaking between any two lats is about 60m, depends on longitudes, but we can be rough
    #  2.0 - 1.0 = 60 m
    #  0.2 - 0.1 = 6 m
    #  0.02 - 0.01 = .6 m (3168 feet, 4 blocks)
    #  0.002 - 0.001 = .06 (300 feet, 100 yards, block size)
    #  0.0002 0 0.0001 = .006 (30 feet - building size)
  
  
    PRECISION = { :half_mile => [2, 0.06],
                  :block =>     [3, 0.006],
                  :building =>  [4, 0.0006],
                  :close =>     [5, 0.00006],
                  :exact =>     [6, 0.000006],
                }
  
          
    def self.reverse_geocode_from_lat_long(latitude, longitude, precision=:half_mile)
      latitude = latitude.to_f
      longitude = longitude.to_f
  
      return nil if latitude.to_i == 0
  
      geo_cache = self.fetch(latitude, longitude, precision)
  
      #puts "GEO_CACHE #{geo_cache.inspect}"
  
      #return geo_cache
  
      if geo_cache.nil?
  
        puts "REVERSE GEOCODING #{latitude}/#{longitude}"
        geo = Pyr::Geo::Coder::reverse_geocode_from_lat_long(latitude, longitude)
        puts "GEO => #{geo.inspect}"
        if geo && geo.latitude && geo.longitude
          geo_cache = GeoCache.new
          geo_cache.geo = geo
          geo_cache = geo_cache.save_unique_or_retry {
            GeoCache.fetch(latitude, longitude, precision)
          }
          self.stash(geo_cache, latitude, longitude, precision)
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
  
    def self.safe(l, precision)
      l = l.to_f
      digits = PRECISION[precision][0]
  
      "%0.0#{digits}f" % l
    end
  
    def self.make_key(latitude, longitude, precision)
      dlat = latitude.to_f
      dlng = longitude.to_f
  
      return nil if dlat.to_i == 0
  
      return "#{safe(dlat, precision)}/#{safe(dlng, precision)}"
    end
  
    def self.fetch(latitude, longitude, precision)
      key = self.make_key(latitude, longitude, precision)
      return nil if key.nil?
  
      GeoCache.cache_fetch(key) {
        puts "GETTING FROM CACHE #{key}"
        dlat = safe(latitude, precision)
        dlng = safe(longitude, precision)
        result = GeoCache.where(:latitude => dlat, :longitude => dlng).first # check exact, we like exact
  
        if result.nil?
          puts "PRECISION #{precision.inspect}"
          scale = PRECISION[precision][1]
  
          result ||= GeoCache.where("latitude <= ?", (latitude + scale)).where("latitude >= ?", (latitude - scale)).where("longitude <= ?", (longitude + scale)).where("longitude >= ?", (longitude - scale)).first
        end
      }
    end
  
    def self.stash(geo_cache, latitude, longitude, precision)
      key = self.make_key(latitude, longitude, precision)
      return nil if key.nil?
  
      GeoCache.cache_write(key, geo_cache)
    end
  
    def shorten_lat_lng
      #puts "SHORTENING"
      self.latitude = GeoCache.safe(self.latitude) if self.latitude
      self.longitude = GeoCache.safe(self.longitude) if self.longitude
    end
    
  end
end
