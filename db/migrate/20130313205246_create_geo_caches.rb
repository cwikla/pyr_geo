class CreateGeoCaches < ActiveRecord::Migration
  def change
    create_table(:geo_caches) do |t|
      t.timestamps
      t.decimal :latitude, :precision => 9, :scale => 6, :null => false
      t.decimal :longitude, :precision => 9, :scale => 6, :null => false
      t.string :city, :limit => 64, :null => false
      t.string :state, :limit => 64, :null => false
      t.string :country, :limit => 2, :null => false
      t.string :postal_code, :limit => 12
      t.string :address
    end

    add_index :geo_caches, [:latitude, :longitude], :unique => true, :name => :gcllidx
    add_index :geo_caches, [:city, :state, :country]
    add_index :geo_caches, [:postal_code, :country]
  end
end
