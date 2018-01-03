require 'geocoder'

module Pyr::Geo::Util
  class Loader

    def self.delete_cities(name)
      name = name.strip.upcase

      GeoCity.delete_all and return if name == "ALL"

      GeoCity.where(:iso_country => name).delete_all
    end

    def self.cities(name)
      encoding = "iso-8859-1:UTF-8"

      GeoCity.reset_column_information
      location = Gem.loaded_specs['pyr_geo'].full_gem_path

      name = name.strip.upcase
      name = "*" if name == "ALL"

      full = "#{location}/data/worldcitiespop/#{name}_dat.txt.gz"

      puts "Loading from : #{full}"

      i = 0
      Pyr::Base::Util::File::unpacker(full, encoding: encoding) do |gzip|
        csv = CSV.new(gzip)
        csv.each do |l|
          i = i + 1
  
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
          if i % 500 == 0
            puts "#{i} => #{gcity.iso_country} | #{gcity.region} | #{gcity.city} | #{gcity.population}"
          end
        end
      end
    end

    def self.delete_country(name)
      name = name.strip.upcase

      GeoName.delete_all and return if name == "ALL"

      GeoName.where(:iso_country => name).delete_all
    end


    def self.country(name)
      cities = {}
      first = {}
  
      name = name.strip.upcase
      name = "*" if name == "ALL"
  
      GeoName.reset_column_information
      location = Gem.loaded_specs['pyr_geo'].full_gem_path

      count = 0
  
      Pyr::Base::Util::File::unpacker("#{location}/data/allCountries/#{name}_dat.txt.gz") do |gzip|
        gzip.each_line do |l|
          count = count + 1
          #puts "++++ => #{l}"
          pieces = l.split("\t").map(&:strip)
          #puts "***** => #{pieces[0]}"
          #puts "-----"
          gname = GeoName.new
          gname.iso_country = pieces[0].upcase
          gname.postal_code = pieces[1].upcase
          gname.name = pieces[2].upcase
  
          gname.admin_name_1 = pieces[3]
          gname.admin_code_1 = pieces[4]
          gname.admin_name_2 = pieces[5]
          gname.admin_code_2 = pieces[6]
          gname.admin_name_3 = pieces[7]
          gname.admin_code_3 = pieces[8]
          gname.latitude = pieces[9].to_f
          gname.longitude = pieces[10].to_f
          gname.accuracy = pieces[10].to_i
          gname.save
 
          if count % 500 == 0 
            puts "#{count} => #{gname.iso_country} | #{gname.name} | #{gname.postal_code}"
          end
  
          key = [gname.iso_country.upcase, gname.postal_code.upcase, gname.name.upcase]
          ll = cities[key] || []
          first[key] ||= gname.id
          ll << [gname.latitude, gname.longitude]
          cities[key] = ll
        end
      end
 
      count = 0 
      puts "Crunching cities"
      cities.each_pair do |key, ll|
        count = count + 1

        latish, longish = Pyr::Geo::Util::Coder::cluster(ll)
        iso_country, name = key
        fid = first[key]
  
        gname = GeoName.find(fid)
        gname.cluster_latitude = latish
        gname.cluster_longitude = longish
        gname.save

        if count % 500 == 0  
          puts "#{count} => Crunched @ #{gname.iso_country} | #{gname.name} | #{gname.postal_code} | #{gname.cluster_latitude},#{gname.cluster_longitude}"
        end
  
      end
    end
  end
end
