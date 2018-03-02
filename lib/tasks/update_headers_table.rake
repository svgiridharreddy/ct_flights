namespace :header_table do 
	desc "create_routes in header" 
	task create_routes: :environment do 
		routes = UniqueRoute.all
		count = 0
		puts "insertion started!"
		routes.find_each do |r|
			route = Header.find_or_create_by(dep_city_code: r.dep_city_code,arr_city_code: r.arr_city_code)
			binding.pry
			puts "#{count+=1} inseterd successfully!"
		end
		puts "insertion completed!"
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
				route = Header.find_or_create_by(dep_city_code: r.dep_city_code,arr_city_code: r.arr_city_code,dep_city_name: r.dep_city_name,arr_city_name: r.arr_city_name)
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
							dep_city_hotels_trains_url = "http://54.169.90.61/hotels/api/#{url_escape(country_name)}/#{url_escape(r.dep_city_name)}.json"
							
							hotels_near_by_airport_response = HTTParty.get(hotels_near_by_airport_url) if lat.present? && long.present?
							parsing_near_by_hotels = JSON.parse(hotels_near_by_airport_response.body) if hotels_near_by_airport_response.present? && hotels_near_by_airport_response.code == 200 

							arr_city_hotels_trians_response = HTTParty.get(arr_city_hotels_trains_url)

							parsing_arr_city_hotels_trains = JSON.parse(arr_city_hotels_trians_response.body) if  arr_city_hotels_trians_response.present? && arr_city_hotels_trians_response.code == 200 

							dep_city_hotels_trians_response = HTTParty.get(dep_city_hotels_trains_url)
							parsing_dep_city_hotels_trains = JSON.parse(dep_city_hotels_trians_response.body) if dep_city_hotels_trians_response.present? && dep_city_hotels_trians_response.code == 200
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
				# route_type = r.hop==0 ? "direct" : 'hop'
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
				binding.pry
				route.save!
				puts "#{count+=1} header record inserted successfully! == #{r.dep_city_code}-#{r.arr_city_code} "
			end
			binding.pry
			puts "#{count}- Total Header insetions completed successfully!" 
		rescue StandardError => e 
			e.message
			e.backtrace
		end
		
	end
end