# nohup bundle exec rake header_table:update_header_details QUEUE="*" --trace > rake.out 2>&1 &

namespace :header_table do 
	desc "create_routes in header" 
	task create_routes: :environment do 
		routes = UniqueRoute.all
		count = 0
		puts "insertion started!"
		routes.find_each do |r|
			route = Header.find_or_create_by(dep_city_code: r.dep_city_code,arr_city_code: r.arr_city_code)
			puts "#{count+=1} inseterd successfully!"
		end
		puts "insertion completed!"
	end
	desc "create_routes in header" 
	task create_routes_from_postgres: :environment do 
		
		routes = FlightRoute.where(page_type: 'flight_schedule',route_type: 'direct')
		count = 0
		puts "insertion started!"
		routes.find_each do |r|
			route = Header.find_by(dep_city_code: r.dep_city_code,arr_city_code: r.arr_city_code)
			if route.nil? || route==""
				hop = r.route_type==="direct" ? 0 : 1
				route = PackageFlightSchedule.find_by(dep_city_code: r.dep_city_code,arr_city_code: r.arr_city_code)
				distance = route.distance
				dep_airport_code = route.dep_airport_code
				arr_airport_code = route.arr_airport_code
				unique_route = UniqueRoute.create(dep_city_code: r.dep_city_code,arr_city_code: r.arr_city_code,dep_city_name: r.dep_city_name,arr_city_name: r.arr_city_name,dep_country_code: r.dep_country_code,arr_country_code: r.arr_country_code,weekly_flights_count: r.flight_count,hop: hop,distance: distance,dep_airport_code: dep_airport_code,arr_airport_code: arr_airport_code)
				header_route = Header.create(dep_city_code: r.dep_city_code,arr_city_code: r.arr_city_code )
				puts "#{count+=1} inseterd successfully! for == #{r.dep_city_code}-#{r.arr_city_code}"
			end
		end
		puts "insertion completed!"
	end

	desc "update dep_city_names and arr_city_names in unique_routes table"
	task :dep_and_arr_cities_name => :environment do 
		CSV.foreach("public/updated_city_list.csv", :headers=>true).each_with_index do |row,index| 
  		begin
        city_code = row[0]
        city_name_en = row[1]

        dep_cities = Header.where(dep_city_code: row[0])

        dep_cities.each do |dep_city|
        	dep_city.dep_city_name = city_name_en
        	dep_city.save!
        end

        arr_cities = Header.where(arr_city_code: row[0])
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
	desc "create header details for routes"
	task update_header_details: :environment do 
		def url_escape(url_string)
      unless url_string.blank?
        result = url_string.encode("UTF-8", :invalid => :replace, :undef => :replace).to_s
        result = result.gsub(/[\/]/,'-')
        result = result.gsub(/[^\x00-\x7F]+/, '') # Remove anything non-ASCII entirely (e.g. diacritics).
        result = result.gsub(/[^\w_ \-]+/i,   '') # Remove unwanted chars.
        result = result.gsub(/[ \-]+/i,      '-') # No more than one of the separator in a row.
        result = result.gsub(/^\-|\-$/i,      '') # Remove leading/trailing separator.
        result = result.downcase
      end
    end
		routes = UniqueRoute.all
		events_cities = ["Bangalore","Mumbai","Hyderabad","New Delhi"]
    weekend_getaway_cities = ["Agra", "Bhopal", "Goa", "Dehradun", "Ahmedabad", "Jammu", "Patna", "Kochi", "New Delhi", "Coorg", "Bangalore", "Mumbai", "Udaipur", "Chennai", "Pune"]
    featured_cities  =  ["Agra", "Gangtok", "Bhopal", "Goa", "Chandigarh", "Amritsar", "Gurgaon", "Dehradun", "Wayanad", "Ahmedabad", "Kolkata", "Kochi", "Jaipur", "Thekkady", "New Delhi", "Coorg", "Kullu", "Bangalore", "Alleppey", "Manali", "Mumbai", "Lucknow", "Hyderabad", "Indore", "Chennai", "Pune"]
    package_cities = ["Dehradun","Ahmedabad","Vijayawada","Rajkot","Belgaum","Leh","Mangalore","Vadodara","Mumbai","Lucknow","Madurai","Goa","Guwahati","Indore","Jaipur","Calicut","Tiruchirappally","Port Blair","Aizawl","Udaipur","Cochin","Raipur","Visakhapatnam","Hyderabad","Coimbatore","Khajuraho","Kullu Manali","Porbandar","Bhopal","Agra","Bangalore","Pune","Kanpur","Ranchi","Jorhat","Visakhapatnam","Mysore","Ranchi","Jodhpur","Dharamsala","Ludhiana","New Delhi","Agartala","Diu","Pantnagar","Bhubaneswar","Srinagar","Jammu","Patna","Hubli","Aurangabad","Shillong","Allahabad","Surat","Imphal","Jabalpur","Kolkata","Trivandrum","Chandigarh","Rajahmundry","Nagpur","Dibrugarh","Varanasi","Bhavnagar","Bhuj","Chennai","Amritsar","Jamnagar","Gwalior","Tirupati","Gorakhpur"]
    things_to_do_cities = ["Coorg","Madikeri","Bhimtal","Agra","Gangtok","Amboli","Junagadh","Srinagar","Munnar","Goa","Mysore","Chandigarh","Mohali","Ghaziabad","Amritsar","Ramanagara","Gadag","Nainital","Gurgaon","New delhi","Noida","Faridabad","Sonipat","Cherrapunjee","Lonavala","Mussoorie","Dehradun","Rishikesh","Jaisalmer","Dharamshala","Ahmedabad","Kolkata","Kochi","Jaipur","Pondicherry","Haridwar","Thekkady","Guwahati","Nashik","Shillong","Hassan","Bandipur","Jodhpur","Trivandrum","Kumbhalgarh","Mahabaleshwar","Binsar","Baiguney","Vijayawada","Ooty","Shimla","Kullu","Bangalore","Alleppey","Manali","Mumbai","Kollam","Alibaug","Kanha","Hyderabad","Udaipur","Chamba","Naukuchiyatal","Chennai","Pune"]
		count = 0 
		begin
			routes.find_each do |r|
				begin
					route = Header.find_by(dep_city_code: r.dep_city_code,arr_city_code: r.arr_city_code)
				dep_city_event = events_cities.include?(r.dep_city_name.titleize) ? "yes" : "no"
				dep_city_weekend_getaway = weekend_getaway_cities.include?(r.dep_city_name.titleize) ? "yes" : "no"
				dep_city_featured = featured_cities.include?(r.dep_city_name.titleize) ? "yes" : "no"
				dep_city_package = package_cities.include?(r.dep_city_name.titleize) ? "yes" : "no"
				dep_city_things_todo = things_to_do_cities.include?(r.dep_city_name.titleize) ? "yes" : "no"
				arr_city_event = events_cities.include?(r.arr_city_name.titleize) ? "yes" : "no"
				arr_city_weekend_getaway = weekend_getaway_cities.include?(r.dep_city_name.titleize) ? "yes" : "no"
				arr_city_featured = featured_cities.include?(r.arr_city_name.titleize) ? "yes" : "no"
				arr_city_package = package_cities.include?(r.arr_city_name.titleize) ? "yes" : "no"
				arr_city_things_todo = things_to_do_cities.include?(r.arr_city_name.titleize) ? "yes" : "no"
				
				if r.arr_city_code.present? && r.arr_country_code.present?
					airport_data = Airport.where(city_code: r.arr_city_code).first
					unless airport_data.present?
						airport_data = Airport.where(city_code: r.dep_city_code).first
					end
					lat =''
					long =''
					if airport_data.present?
						lat = airport_data.latitude.present? ? airport_data.latitude: ""
						long = airport_data.longitude.present? ? airport_data.longitude: ""
						country_name = airport_data.country_name
					end
					hotel_details = {"near_by_hotels" => [],
						"city_top_hotels" => [],
						"types_of_hotels" => []
					}
					train_details = { "origin_from" => [],
						"passing_from" => [],
						"train_stations" => { "dep_stations" => [],
							"arr_stations" => []
						}
					}
					
					if country_name.present?
						hotels_near_by_airport_url = "http://54.169.90.61/hotels/api/#{url_escape(country_name)}/near-by-hotels?lat=#{lat}&long=#{long}"
						arr_city_hotels_trains_url = "http://54.169.90.61/hotels/api/#{url_escape(country_name)}/#{url_escape(airport_data.city_name)}.json"
						hotels_near_by_airport_response = HTTParty.get(hotels_near_by_airport_url) if lat.present? && long.present?
						parsing_near_by_hotels = JSON.parse(hotels_near_by_airport_response.body) if hotels_near_by_airport_response.present? && hotels_near_by_airport_response.code == 200 

						arr_city_hotels_trians_response = HTTParty.get(arr_city_hotels_trains_url)

						parsing_arr_city_hotels_trains = JSON.parse(arr_city_hotels_trians_response.body) if  arr_city_hotels_trians_response.present? && arr_city_hotels_trians_response.code == 200 

						if parsing_near_by_hotels == nil
							parsing_near_by_hotels["hotels"] = parsing_arr_city_hotels_trains["hotels"] rescue []
						end
						hotel_details["near_by_hotels"] = parsing_near_by_hotels["hotels"] rescue []
						hotel_details["city_top_hotels"] = parsing_arr_city_hotels_trains["hotels"]  rescue []
						hotel_details["types_of_hotels"] = parsing_arr_city_hotels_trains["properties"] rescue []
						train_details["origin_from"] = parsing_arr_city_hotels_trains["trains"][0]["origin_from"] rescue []
						train_details["passing_from"] = parsing_arr_city_hotels_trains["trains"][1]["passing_from"] rescue []
						train_details["train_stations"]["dep_stations"] = parsing_dep_city_hotels_trains["train_stations"] rescue []
						train_details["train_stations"]["arr_stations"] = parsing_arr_city_hotels_trains["train_stations"] rescue []
					end
				end
				unless hotel_details.nil? || hotel_details=='' 
					route.update(header_status: "created")
				else
					route.update(header_status: "failed")
				end
				# route_type = r.hop==0 ? "direct" : 'hop'
					route.dep_city_name = r.dep_city_name
					route.arr_city_name = r.arr_city_name
					route.hotel_details = hotel_details.to_s rescue nil
					route.trains_details = train_details.to_s rescue nil
					route.dep_city_event = dep_city_event rescue ""
					route.dep_city_weekend_getaway = dep_city_weekend_getaway rescue ""
					route.dep_city_featured = dep_city_featured rescue ""
					route.dep_city_package = dep_city_package rescue ""
					route.dep_city_things_todo = dep_city_things_todo rescue ""
					route.arr_city_event = arr_city_event rescue ""
					route.arr_city_weekend_getaway = arr_city_weekend_getaway rescue ""
					route.arr_city_featured = arr_city_featured rescue ""
					route.arr_city_package = arr_city_package rescue ""
					route.arr_city_things_todo = arr_city_things_todo rescue ""
					route.save
					puts "#{count+=1} header record inserted successfully! == #{r.dep_city_code}-#{r.arr_city_code} "
				rescue StandardError => e 
					e.message
					e.backtrace
				end
			end
			puts "#{count}- Total Header insetions completed successfully!" 
		rescue StandardError => e 
			e.message
			e.backtrace
		end
		
	end
end