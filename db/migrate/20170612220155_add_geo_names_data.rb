# This migration comes from pyr_geo_engine (originally 20170612220155)
class AddGeoNamesData < ActiveRecord::Migration[5.0]
  def up
    cities = {}
    first = {}

    GeoName.reset_column_information
    location = Gem.loaded_specs['pyr_geo'].full_gem_path

    File.open("#{location}/data/allCountries.txt").each do |l|
      #puts "++++ => #{l}"
			pieces = l.split("\t").map(&:strip)
      #puts "***** => #{pieces[0]}"
      #puts "-----"
			gname = GeoName.new
      i = 0
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

      puts gname.inspect

      key = [gname.iso_country, gname.name.upcase]
      ll = cities[key] || []
      first[key] ||= gname.id
      ll << [gname.latitude, gname.longitude]
      cities[key] = ll
    end

    puts "Crunching cities" 
    cities.each_pair do |key, ll|
      latish, longish = Pyr::Geo::Util::Coder::cluster(ll)
      iso_country, name = key
      fid = first[key]
      
      gname = GeoName.find(fid)
      gname.cluster_latitude = latish
      gname.cluster_longitude = longish
      gname.save
      puts gname.inspect

    end
  end

  def down
  end
end
