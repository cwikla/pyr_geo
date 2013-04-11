module Tgp
  module Geo
    module Generators
      class AddToGenerator < ::Rails::Generators::Base
        include Rails::Generators::Migration
  
        source_root File.expand_path('../templates', __FILE__)
  
        argument :model_name, :type => :string
  
        desc "Add tgp geo records to a model"
  
        def self.next_migration_number(path)
          unless @prev_migration_nr
            @prev_migration_nr = Time.now.utc.strftime("%Y%m%d%H%M%S").to_i
          else
            @prev_migration_nr += 1
          end
          @prev_migration_nr.to_s
        end
  
        def copy_migrations
          migration_template "migrations/tgp_geo_add_to_model.rb", "db/migrate/add_to_#{model_name}.tgp_geo.rb"
        end
  
      end
    end
  end
end
