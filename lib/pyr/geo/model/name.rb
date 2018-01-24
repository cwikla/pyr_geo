
module Pyr
  module Geo::Model
    module Name
      extend ActiveSupport::Concern
    
      included do
        self.table_name = "pyr_geo_names"
      end
    
      module ClassMethods
        def looks_postal?(s)
          s ||= ""
          s = s.strip
          ((s =~ /^[0-9]/) || (s =~ /^[a-zA-Z]\d/))
        end

        def like(gn)
          name = gn.name.downcase
          admin_code_1 = gn.admin_code_1.downcase
          iso_country = (gn.iso_country || "US").downcase

          where("lower(name) = ?", name).where("lower(admin_code_1) = ?", admin_code_1).where("lower(iso_country) = ?", iso_country)
        end

        def is_primary
          where(is_primary: true)
        end

        def geo_distance(lat1, lng1, lat2, lng2) 
          select("pyr_geo_distance(?, ?, ?, ?)", lat1, lng2, lat2, lng2)
        end

        def postal_search(s, **options)
          #country = options[:country] || "US"

          s = (s || "").strip.downcase

          #where(iso_country: country).where("postal_code like (?)", "#{s}%")
          where("lower(postal_code) like (?)", "#{s.strip.downcase}%")
        end

        def city_search(s, **options)
          country = options[:country] || "US"

          s = (s || "").strip.downcase

          where(iso_country: country).where("lower(name) like (?)", "#{s.strip.downcase}%")
        end

        def search(s, **options)
          s = s.strip.downcase
        
          is_postal = looks_postal?(s)

          results = postal_search(s, **options) if is_postal
          results = city_search(s, **options) if !results

          results
        end

      end
    
    end
  end
end
