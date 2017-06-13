
module Pyr
  module Geo::Model
    module Name
      extend ActiveSupport::Concern
    
      included do
        self.table_name = "pyr_geo_names"
      end
    
      module ClassMethods
      end
    
    end
  end
end
