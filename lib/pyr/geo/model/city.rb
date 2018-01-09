
module Pyr
  module Geo::Model
    module City
      extend ActiveSupport::Concern
    
      included do
        self.table_name = "pyr_geo_cities"
      end
    
      module ClassMethods
        def postal_search(s, **options)
          country = options[:country] || "US"

          where(iso_country: country).where("postal_code like (?)", "#{s}%")
        end

        def search(s, **options)
          country = options[:iso_country] || "US"

          s = s.strip.downcase
          return postal_search(s) if s =~ /^[0..9]/

          where(iso_country: country).where("lower(name) like (?)", "#{s}%")
        end
      end
    
    end
  end
end
