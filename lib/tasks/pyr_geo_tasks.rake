# desc "Explaining what the task does"
# task :pyr_geo do
#   # Task goes here
# end

desc "Add geo location columns to a table"
namespace :pyr_geo_engine do
  task :add_geo_cols, [:model_name]  => :environment  do |t, args|
    name = args[:model_name]
    system "rails g pyr:geo:add_to #{name}"
  end
end
