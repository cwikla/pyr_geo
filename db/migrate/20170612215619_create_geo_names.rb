class CreateGeoNames < ActiveRecord::Migration[5.0]
  def change
    create_table :pyr_geo_names do |t|
      t.timestamps
      t.string :iso_country, :limit => 2, :null => false
      t.string :postal_code, :limit => 20
      t.string :place_name, :null => false
      t.string :admin_name_1, :limit => 100
      t.string :admin_code_1, :limit => 20
      t.string :admin_name_2, :limit => 100
      t.string :admin_code_2, :limit => 20
      t.string :admin_name_3, :limit => 100
      t.string :admin_code_3, :limit => 20
      t.decimal :latitude, :precision => 9, :scale => 6, :null => false
      t.decimal :longitude, :precision => 9, :scale => 6, :null => false
    end

    add_index :pyr_geo_names, [:iso_country, :name]
    add_index :pyr_geo_names, [:iso_country, :postal_code]
    add_index :pyr_geo_names, [:latitude, :longitude , :iso_country, :name], :name => :pyr_geo_llin_idx
  end
end
