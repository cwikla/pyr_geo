module GeoRecord
  extend ActiveSupport::Concern

  included do
    before_save :update_geo
    attr_accessible :latitude,
                         :longitude,
                         :country,
                         :state,
                         :city,
                         :postal_code,
                         :address
   
    attr_accessor :geo_moved_alot

    geocoded_by :full_address
  end

  module ClassMethods
    def by_geo(geo)
      p = self
      #p = p.where(:postal_code => geo.postal_code) if geo.postal_code
      p = p.where(:city => geo.city) if geo.city
      p = p.where(:state => geo.state) if geo.state
      p = p.where(:country => geo.country) if geo.country
      return p
    end
  end

  module InstanceMethods
    def moved_alot?
      #puts "MOVED ALOT #{geo_moved_alot}"
      @geo_moved_alot ||= (self.city_changed? || self.state_changed? || self.country_changed?)
    end
  
    def full_address
      [city, state, country].compact.join(',')
    end
  
    def geo_s
      pieces = []
      pieces << "#{self.country.strip}" if self.country
      pieces << "#{self.state.strip}" if self.state
      pieces << "#{self.city.strip}" if self.city
      return pieces.join("/")
    end
  
    def no_geo?
      return self.city.blank? || self.state.blank?
    end
  
    def needs_update?
      return (self.no_geo? || self.latitude_changed? || self.longitude_changed?) && !self.latitude.blank? && !self.longitude.blank?
    end
    
    def update_geo
      #puts "UPDATE GEO 2", self.latitude_changed?, self.longitude_changed?
      if self.needs_update?
  
        #puts "UPDATEING GEO"
        new_geo = GeoCache::reverse_geocode_from_lat_long(self.latitude, self.longitude) # can also make a background job so it gets updated later
        #puts "NEW GEO #{new_geo.inspect}"
  
        if new_geo
          self.geo = new_geo
          self.moved_alot?
        end
      end
  
      return
    end
    
    def geo
      g = Geo.new
    
      g.latitude = self.latitude
      g.longitude = self.longitude
      g.country = self.country
      g.state = self.state
      g.city = self.city
      g.postal_code = self.postal_code
      return g
    end
    
    def geo=(obj)
      if obj.respond_to? :latitude
        self.latitude = obj.latitude
        self.longitude = obj.longitude
        self.country = obj.country
        self.state = obj.state
        self.city = obj.city
        self.postal_code = obj.postal_code
      else
        self.latitude = vars[:latitude] if vars[:latitude]
        self.longitude = vars[:longitude] if vars[:longitude]
        self.country = vars[:country] if vars[:country]
        self.state = vars[:state] if vars[:state]
        self.city = vars[:city] if vars[:city]
        self.postal_code = vars[:postal_code] if vars[:postal_code]
        #self.address = vars[:address] if vars[:address]
      end
    end
  end
end
