class Reprimary < ActiveRecord::Migration[5.1]
  def change
    GeoName.reset_column_information

    Pyr::Geo::Util::Loader::reprimary
  end
end
