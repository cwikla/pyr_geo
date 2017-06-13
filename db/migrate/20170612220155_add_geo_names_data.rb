class AddGeoNamesData < ActiveRecord::Migration[5.0]
  def up
    GeoName.reset_column_information

    File.open("#{RAILS_ROOT}/data/allCountries.txt").each do |l|
      puts l
    end
  end

  def down
  end
end
