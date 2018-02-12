require "csv"

namespace :update do 
	desc "update dep_city_names and arr_city_names in unique_routes table"

	task :dep_and_arr_cities_name => :environment do 
		CSV.foreach("public/updated_city_list.csv", :headers=>true).each_with_index do |row,index| 
			begin
        city_code = row[0]
        city_name_en = row[1]

        dep_cities = UniqueRoute.where(dep_city_code: row[0])

        dep_cities.each do |dep_city|
        	dep_city.dep_city_name = city_name_en
        	dep_city.save!
        end

        arr_cities = UniqueRoute.where(arr_city_code: row[0])
        arr_cities.each do |arr_city|
        	arr_city.arr_city_name = city_name_en
        	arr_city.save!
        end
        puts "#{index}-city_code=#{city_code} with dep_city_count=#{dep_cities.count} and arr_city_count=#{arr_cities.count}"
      rescue StandardError => e
      	binding.pry
      end
		end

	end

end 
