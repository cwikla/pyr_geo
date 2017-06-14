class CreateGeoCities < ActiveRecord::Migration[5.0]
  def change
    create_table :geo_cities do |t|
      t.timestamps
      t.string :iso_country, :limit => 2, :null => false
      t.string :city_normalized, :null => false
      t.string :city, :null => false
      t.integer :region, :null => false
      t.integer :population, :default => 0
      t.decimal :latitude, :precision => 9, :scale => 6, :null => false
      t.decimal :longitude, :precision => 9, :scale => 6, :null => false
    end

    add_index :geo_cities, [:latitude, :longitude, :iso_country, :city], :name => :gc_llic_idx
    add_index :geo_cities, [:iso_country, :city, :population]
  end
end
