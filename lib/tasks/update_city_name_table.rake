require "csv"

namespace :city_name_table do 
	desc "update city names with en,ar,hi"
	task :update_with_names  => :environment do

    CSV.foreach("public/updated_city_list.csv", :headers=>true).each_with_index do |row,index| 
      begin
        city_code = row[0]
        city_name_en = row[1]
        city_name_hi = row[2]
        city_name_ar = row[3]

        city = CityName.find_or_create_by(:city_code => city_code)
         city.city_name_en = city_name_en
         city.city_name_ar = city_name_ar
         city.city_name_hi = city_name_hi
         city.save
        puts "#{index} - Inserted for City - #{city_code}"
      rescue StandardError => e
        binding.pry
        puts "Exception Occured while adding city data " + e.message
      end
    end
	end

	desc "get null city names from package_flight_scheduels"
	task :get_null_cities => :environment do 
		null_name_dep_cities = PackageFlightSchedule.where("dep_city_name IS NULL").pluck(:dep_city_code).uniq
		null_name_arr_cities = PackageFlightSchedule.where("arr_city_name IS NULL").pluck(:arr_city_code).uniq
		total_null_city_codes = (null_name_dep_cities + null_name_arr_cities).uniq
    dep_cities_with_names = PackageFlightSchedule.where("dep_city_name IS NOT NULL").pluck(:dep_city_code).uniq
    arr_cities_with_names = PackageFlightSchedule.where("arr_city_name IS NOT NULL").pluck(:arr_city_code).uniq
    total_cities_with_names = (dep_cities_with_names + arr_cities_with_names).uniq
	end

end
