# namespace :get do 
# 	task :all_cities => :environment do 
# 		dep_cities = PackageFlightSchedule.all.pluck(:dep_cityc_code).uniq
# 		arr_cities = PackageFlightSchedule.all.pluck(:arr_cityc_code).uniq
# 		result = arr_cities - dep_cities
# 		result1 = dep_cities - arr_cities
# 		final_result = (dep_cities + result + result1).uniq
# 		final_result.each do |city|
# 			CSV.open("#{Rails.root}/no_names_airlines.csv","w") do |csv|
#         		attributes = %w( city_code  country_code city_name_en city_name_ar city_name_hi )
# 		end
# 	end
# end