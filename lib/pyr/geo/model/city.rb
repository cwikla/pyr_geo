
module Pyr
  module Geo::Model
    module City
      extend ActiveSupport::Concern
    
      included do
        self.table_name = "pyr_geo_cities"
      end
    
      module ClassMethods
      end
    
    end
  end
end
