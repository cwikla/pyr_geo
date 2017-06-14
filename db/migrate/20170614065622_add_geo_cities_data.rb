require 'csv'

class AddGeoCitiesData < ActiveRecord::Migration[5.0]
  def up
    GeoCity.reset_column_information
    location = Gem.loaded_specs['pyr_geo'].full_gem_path

    Pyr::Base::Util::File::unpacker("#{location}/data/worldcitiespop/*.gz", encoding: "windows-1251:utf-8") do |gzip|
      i = 0
      csv = CSV.new(gzip)
      csv.each do |l|
        i = i + 1
        next if i == 1
    
		    pieces = l.map{ |x| x.nil? ? nil : x.strip }
		    gcity = GeoCity.new
		    gcity.iso_country = pieces[0].upcase
        gcity.city_normalized = pieces[1]
        gcity.city = pieces[2]
    
        gcity.region = pieces[3].to_i
        gcity.population = pieces[4].to_i
        gcity.latitude = pieces[5].to_f
        gcity.longitude = pieces[6].to_f
    
        gcity.save

        puts "#{gcity.iso_country} | #{gcity.city} | #{gcity.population}"
      end
    end
  end

  def down
  end
end
