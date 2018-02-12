namespace :update do 
	desc "update dep and arr cities in package_flight_schedules"
	task dep_and_arr_cities: :environment do
	 puts '--------Start adding Cities --------'
   csv_file = "#{APP_ROOT}/public/updated_city_list.csv"

   csv_text = File.read(csv_file)
   csv = CSV.parse(csv_text, headers: :first_row, col_sep: ",")
   count = 0
   csv.each do |row|
	    begin
	      city_code = row[0]
	      city_name_en = row[1]
	      dep_cities = PackageFlightSchedule.where(dep_city_code: city_code)
	      dep_cities.each do |dep_city|
	      	dep_city.update(dep_city_name: city_name_en)
	      end
	      arr_cities = PackageFlightSchedule.where(arr_city_code: city_code)
	      arr_cities.each do |arr_city|
	      	arr_city.update(arr_city_name: city_name_en)
	      end
	    rescue StandardError => e
	    	binding.pry
	    end
    end
	end
end