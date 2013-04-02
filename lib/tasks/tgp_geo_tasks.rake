# desc "Explaining what the task does"
# task :tgp_geo do
#   # Task goes here
# end

desc "Add geo location columns to a table"
namespace :tgp_geo_engine do
  task :add_records, [:table_name]  => :environment  do |t, args|
  #  c = ActiveRecord::Base.connection
  #  table_name = args.table_name
#
#    c.add_column table_name, :latitude, :precision => 9, :scale => 6, :null => false
#    c.add_column table_name, :longitude, :precision => 9, :scale => 6, :null => false
#    c.add_column table_name, :city, :limit => 64, :null => false
#    c.add_column table_name, :state, :limit => 64, :null => false
#    c.add_column table_name, :country, :limit => 2, :null => false
#    c.add_column table_name, :postal_code, :limit => 12
#    c.add_column table_name, :address
#
#    c.add_index table_name, [:latitude, :longitude]
#    c.add_index table_name, [:city, :state, :country]
#    c.add_index table_name, [:postal_code, :country]

  end
end
