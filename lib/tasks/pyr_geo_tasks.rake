# desc "Explaining what the task does"
# task :pyr_geo do
#   # Task goes here
# end

desc "Add geo location columns to a table"
namespace :pyr_geo_engine do
  task :add_geo_cols, [:model_name]  => :environment  do |t, args|
    name = args[:model_name]
    system "rails g pyr:geo:add_to #{name}"
  end
end

desc "Load country information to the GeoName table from data files"
namespace :pyr_geo_engine do
  task :load_country_info, [:country] => :environment do |t, args|
    name = args[:country]

    Pyr::Geo::Util::Loader::country(name)
  end
end

desc "Remove country information from the GeoName table"
namespace :pyr_geo_engine do
  task :remove_country_info, [:country] => :environment do |t, args|
    name = args[:country]

    Pyr::Geo::Util::Loader::delete_country(name)
  end
end

desc "Load cities, lat,lng and population information to the GeoCity table from data files"
namespace :pyr_geo_engine do
  task :load_cities, [:country] => :environment do |t, args|
    name = args[:country]
    Pyr::Geo::Util::Loader::cities(name)
  end
end

desc "Remove cities, lat,lng and population information from the GeoCity table"
namespace :pyr_geo_engine do
  task :remove_cities, [:country] => :environment do |t, args|
    name = args[:country]
    Pyr::Geo::Util::Loader::delete_cities(name)
  end
end
