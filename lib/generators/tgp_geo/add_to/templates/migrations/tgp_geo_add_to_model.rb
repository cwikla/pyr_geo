class AddTo<%= model_name.camelcase %> < ActiveRecord::Migration
  def change
    table_name = "<%= model_name.pluralize.tableize %>".to_sym
    add_column table_name, :latitude, :decimal, :precision => 9, :scale => 6
    add_column table_name, :longitude, :decimal, :precision => 9, :scale => 6
    add_column table_name, :city, :string, :limit => 64
    add_column table_name, :state, :string, :limit => 64
    add_column table_name, :country, :string, :limit => 2
    add_column table_name, :postal_code, :string, :limit => 12
    add_column table_name, :address, :string

    add_index table_name, [:latitude, :longitude]
    add_index table_name, [:city, :state, :country]
    add_index table_name, [:postal_code, :country]
  end
end
