class AddPrimary < ActiveRecord::Migration[5.1]
  def change
    add_index :pyr_geo_names, "lower(name), lower(admin_code_1), lower(iso_country)", name: :pyr_geo_low_idx

    add_column :pyr_geo_names, :is_primary, :boolean, default: false, null: false
  end
end

