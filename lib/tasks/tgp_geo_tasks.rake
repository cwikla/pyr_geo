# desc "Explaining what the task does"
# task :tgp_geo do
#   # Task goes here
# end

desc "Add geo location columns to a table"
namespace :tgp_geo_engine do
  task :add_records, [:model_name]  => :environment  do |t, args|
    name = args[:model_name]
    system "rails g tgp_geo:add_to #{name}"
  end
end
