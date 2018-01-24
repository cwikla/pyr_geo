class SetPrimary < ActiveRecord::Migration[5.1]
  def change
    Pyr::Geo::Util::Loader::set_primary
  end
end
