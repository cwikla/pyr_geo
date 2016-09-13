require 'geocoder'

module Pyr
  module Geo::Model
    module Geo
      extend ActiveSupport::Concern
    
      included do
        class << self; attr_accessor :pyr_geo_variables end
        @pyr_geo_variables = {}
  
        before_save :check_copy_on
        before_save :update_geo
        #attr_accessible :latitude,
                             #:longitude,
                             #:country,
                             #:state,
                             #:city,
                             #:postal_code,
                             #:address
       
        attr_accessor :geo_moved_alot
    
        geocoded_by :full_address
      end
    
      module ClassMethods
        def before_created_copies_geo_from(obj_sym)
          @pyr_geo_variables[:copy_sym] = obj_sym
        end

        def close_to(latitude, longitude, distance)
          p = self
          p = p.select("*").select("pyr_geo_distance(latitude, longitude, #{latitude}, #{longitude}) as geo_distance")
          p = p.where("pyr_geo_distance(latitude, longitude, ?, ?) <= ?", latitude, longitude, distance)

					puts p.inspect

          return p
        end
  
        def by_geo(geo)
          p = self
          #p = p.where(:postal_code => geo.postal_code) if geo.postal_code
          p = p.where(:city => geo.city) if geo.city
          p = p.where(:state => geo.state) if geo.state
          p = p.where(:country => geo.country) if geo.country
          return p
        end
    
        def geo_precision
          @pyr_geo_variables[:geo_precision] ||= Pyr::Geo::Engine.config.pyr_geo_precision
        end
      end
    
      def moved_alot?
        Rails.logger.debug "MOVED ALOT #{geo_moved_alot}"
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
  
      def check_copy_on
        if self.class.pyr_geo_variables[:copy_sym]
          proxy = self.send(self.class.pyr_geo_variables[:copy_sym])
          self.geo = proxy.geo if !proxy.nil?
        end
      end
      
      def update_geo
        Rails.logger.debug "UPDATE GEO 2, #{self.latitude_changed?}, #{self.longitude_changed?}"
  
        if !self.class.pyr_geo_variables[:copy_sym] && self.needs_update?
    
          Rails.logger.debug "UPDATEING GEO"
          new_geo = Pyr::Geo::GeoCache::reverse_geocode_from_lat_long(self.latitude, self.longitude, self.class.geo_precision) # can also make a background job so it gets updated later
          Rails.logger.debug "NEW GEO #{new_geo.inspect}"
    
          if new_geo
            self.geo = new_geo
            self.moved_alot?
          end
        end
    
        return
      end
      
      def geo
        g = Pyr::Geo::Model::Geo.new
      
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
end
