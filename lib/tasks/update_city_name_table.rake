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

  desc "update city names with en,ar,hi"
  task :update_with_content => :environment do
    begin
      city_content = File.open("#{Rails.root}/public/flight_schedule_content/#{@flight_route.dep_city_name.titleize}-#{@flight_route.dep_city_code}.txt","r:bom|utf-8").read.force_encoding("UTF-8") rescue nil
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

	desc "get null city names from package_flight_scheduels"
	task :get_null_cities => :environment do 
		null_name_dep_cities = PackageFlightSchedule.where("dep_city_name IS NULL").pluck(:dep_city_code).uniq
		null_name_arr_cities = PackageFlightSchedule.where("arr_city_name IS NULL").pluck(:arr_city_code).uniq
		total_null_city_codes = (null_name_dep_cities + null_name_arr_cities).uniq
    dep_cities_with_names = PackageFlightSchedule.where("dep_city_name IS NOT NULL").pluck(:dep_city_code).uniq
    arr_cities_with_names = PackageFlightSchedule.where("arr_city_name IS NOT NULL").pluck(:arr_city_code).uniq
    total_cities_with_names = (dep_cities_with_names + arr_cities_with_names).uniq
	  resutlt = (total_null_city_codes + total_cities_with_names).uniq
    count = 0
    CSV.open("#{Rails.root}/all_cities_dynamic.csv","w") do |csv|
      attributes = %w( city_code city_name_en city_name_hi city_name_ar)
        csv << attributes
      resutlt.each do |city_code|
        city = CityName.find_by(city_code: city_code)
        binding.pry
        if city.present? && !city.nil? 
          city_name_en = city.city_name_en
          city_name_ar = city.city_name_ar
          city_name_hi = city.city_name_hi
          binding.pry
          csv << [city_code,city_name_en,city_name_hi,city_name_ar]

        else
          csv << [city_code,'','','']
          CSV.open("#{Rails.root}/no_name_cities.csv","w") do |csv1|
            attributes = %w( city_code city_name_en city_name_hi  city_name_ar)
            csv1 << attributes
            csv1 << [city_code,'','','']
          end
        end
        puts "#{count+=1} written for city-#{city_code}"
      end
    end
  end

  desc "get null airport names"
  task :get_null_airports => :environment do 
    dep_airports = PackageFlightSchedule.all.pluck(:dep_airport_code).uniq
    arr_airports = PackageFlightSchedule.all.pluck(:arr_airport_code).uniq
    total_airports = (dep_airports + arr_airports).uniq
    
    count = 0
    CSV.open("#{Rails.root}/all_airports_dynamic.csv","w") do |csv|
      attributes = %w( airport_code city_code airport_name_en airport_name_ar airport_name_hi address phone email website)
        csv << attributes
      total_airports.each do |airport_code|
        airport = Airport.find_by(airport_code: airport_code)
        if airport.present? && !airport.nil? 
          city_code = airport.city_code
          airport_name_en = airport.airport_name
          airport_name_ar = ''
          airport_name_hi = ''
          address = airport.address
          phone = airport.phone
          email = airport.email
          csv << [airport_code,city_code,airport_name_en,airport_name_ar,airport_name_hi,address,phone,email]
        else
          csv << [airport_code,'','','','','','','']
          CSV.open("#{Rails.root}/no_name_airports.csv","w") do |csv1|
            attributes = %w( airport_code city_code airport_name_en airport_name_ar airport_name_hi address phone email website)
            csv1 << attributes
            csv1 << [airport_code,'','','','','','','']
          end
        end
        puts "#{count+=1} written for airport-#{airport_code}"
      end
    end
  end
end
