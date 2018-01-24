class Recluster < ActiveRecord::Migration[5.1]
  def up
    Pyr::Geo::Util::Loader::recluster
  end
end
