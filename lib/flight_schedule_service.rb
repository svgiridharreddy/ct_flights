require 'net/http'

class FlightScheduleService
	def initialize(args={})
	    @dep_city_code = args[:dep_city_code] || args[:city_code]
	    @arr_city_code = args[:arr_city_code]
	    @dep_city_name = args[:dep_city_name]
	    @arr_city_name = args[:arr_city_name]
	    @dep_country_code = args[:dep_country_code]
	    @arr_country_code = args[:arr_country_code]
	    @country_code = args[:country_code]
	    @section = args[:section]
	    @language = args[:language]
  	  @route = args[:route]
      @country_name = args[:country_name]
      @domestic_carrier_codes = AirlineBrand.where(country_code: @country_code).pluck("distinct(carrier_code)") 
    end

    def schedule_airline_values
      I18n.locale = @language.to_sym
    	route_values = {}
    	dep_city_name_formated = url_escape(@dep_city_name) rescue ""
    	arr_city_name_formated = url_escape(@arr_city_name) rescue ""
    	return_url = arr_city_name_formated +"-"+dep_city_name_formated +"-flights.html" rescue ""
			top_dom_cc = AirlineBrand.where(country_code: @country_code).order("brand_routes_count desc").limit(8).pluck(:carrier_code)
			top_dom_airlines = top_dom_cc.map{|cc| I18n.t("airlines.#{cc}")}
			top_int_cc = AirlineBrand.where.not(country_code: @country_code).order("brand_routes_count desc").limit(8).pluck(:carrier_code)
			top_int_airlines = top_int_cc.map{|cc| I18n.t("airlines.#{cc}") } 
			route_values["return_url"] = return_url
			route_values["dep_city_name_formated"] = dep_city_name_formated rescue ""
			route_values["arr_city_name_formated"] = arr_city_name_formated rescue ""
			route_values["top_dom_airlines"] = top_dom_cc
			route_values["top_int_airlines"] = top_int_cc  
			return route_values
    end

    def fetch_route_content
    	content = {"unique_route_content" => "",
    				"dep_city_content" => "",
    				"arr_city_content" => ""}
    	
    	if I18n.t("flight_schedule_content.#{@country_code.downcase}.#{@dep_city_name}-#{@arr_city_name}-Flights").index("translation missing").nil? 
    		unique_route_content = I18n.t("flight_schedule_content.#{@dep_city_name}-#{@arr_city_name}-Flights")
    		content["unique_route_content"] = unique_route_content 
    	else
    		dep_city = CityContent.find_by(city_code: @dep_city_code)
    		arr_city = CityContent.find_by(city_code: @arr_city_code)
    		country_code = @country_code.downcase
    		language = @language.downcase
    		country_lang = "content_"+"#{@country_code.downcase}_#{@language.downcase}"
    		content["dep_city_content"]= dep_city.send(country_lang) rescue nil
    		content["arr_city_content"] = arr_city.send(country_lang)	rescue nil
    	end
    	return content
    end

    def get_airport_deatils
      airport_details = {}
    	@airports = Hash[Airport.where(:city_code=>[@dep_city_code,@arr_city_code]).map{|c| [c.city_code,c]}]
      airport_details['dep_airport_name'] = @airport[@dep_city_code].airport_name rescue ""
      airport_details['arr_airport_name'] = @airports[@arr_city_code].airport_name rescue ""
      airport_details['dep_airport_address'] = @airports[@dep_city_code].address rescue ""
      airport_details['arr_airport_address'] = @airports[@arr_city_code].address rescue ""
      airport_details['dep_airport_phone'] = @airports[@dep_city_code].phone rescue ""
      airport_details['arr_airport_phone'] = @airports[@arr_city_code].phone rescue ""
      airport_details['dep_airport_email'] = @airports[@dep_city_code].email rescue ""
      airport_details['arr_airport_email'] = @airports[@arr_city_code].email rescue ""
      airport_details['dep_airport_website'] = @airports[@dep_city_code].website rescue ""
      airport_details['arr_airport_website'] = @airports[@arr_city_code].website rescue ""
      return airport_details
    end

  	def schedule_header_details 
      flights_header = {}  
      top_dom_cc = AirlineBrand.where(country_code: @country_code).order("brand_routes_count desc").limit(8).pluck(:carrier_code)
      route_dom_airlines = PackageFlightSchedule.where(dep_city_code: @dep_city_code,arr_city_code: @arr_city_code,carrier_code: top_dom_cc).pluck(:carrier_code).uniq
      route_int_airlines = PackageFlightSchedule.where(dep_city_code: @dep_city_code,arr_city_code: @arr_city_code).where.not(carrier_code: top_dom_cc).pluck(:carrier_code).uniq
      flights_header["dom_airlines"] = route_dom_airlines
      flights_header["int_airlines"] = route_int_airlines
      
      dep_city_weekend_getaway = false
      dep_featured_city = false
      dep_city_package = false
      dep_events_city = false
      dep_city_things_to_do = false
      arr_city_weekend_getaway = false
      arr_featured_city = false
      arr_city_package = false
      arr_events_city = false
      arr_city_things_to_do = false

      events_cities = ["Bangalore","Mumbai","Hyderabad","New Delhi"]
      weekend_getaway_cities = ["Agra", "Bhopal", "Goa", "Dehradun", "Ahmedabad", "Jammu", "Patna", "Kochi", "New Delhi", "Coorg", "Bangalore", "Mumbai", "Udaipur", "Chennai", "Pune"]
      featured_cities  =  ["Agra", "Gangtok", "Bhopal", "Goa", "Chandigarh", "Amritsar", "Gurgaon", "Dehradun", "Wayanad", "Ahmedabad", "Kolkata", "Kochi", "Jaipur", "Thekkady", "New Delhi", "Coorg", "Kullu", "Bangalore", "Alleppey", "Manali", "Mumbai", "Lucknow", "Hyderabad", "Indore", "Chennai", "Pune"]
      package_cities = ["Dehradun","Ahmedabad","Vijayawada","Rajkot","Belgaum","Leh","Mangalore","Vadodara","Mumbai","Lucknow","Madurai","Goa","Guwahati","Indore","Jaipur","Calicut","Tiruchirappally","Port Blair","Aizawl","Udaipur","Cochin","Raipur","Visakhapatnam","Hyderabad","Coimbatore","Khajuraho","Kullu Manali","Porbandar","Bhopal","Agra","Bangalore","Pune","Kanpur","Ranchi","Jorhat","Visakhapatnam","Mysore","Ranchi","Jodhpur","Dharamsala","Ludhiana","New Delhi","Agartala","Diu","Pantnagar","Bhubaneswar","Srinagar","Jammu","Patna","Hubli","Aurangabad","Shillong","Allahabad","Surat","Imphal","Jabalpur","Kolkata","Trivandrum","Chandigarh","Rajahmundry","Nagpur","Dibrugarh","Varanasi","Bhavnagar","Bhuj","Chennai","Amritsar","Jamnagar","Gwalior","Tirupati","Gorakhpur"]
      things_to_do_cities = ["Coorg","Madikeri","Bhimtal","Agra","Gangtok","Amboli","Junagadh","Srinagar","Munnar","Goa","Mysore","Chandigarh","Mohali","Ghaziabad","Amritsar","Ramanagara","Gadag","Nainital","Gurgaon","New delhi","Noida","Faridabad","Sonipat","Cherrapunjee","Lonavala","Mussoorie","Dehradun","Rishikesh","Jaisalmer","Dharamshala","Ahmedabad","Kolkata","Kochi","Jaipur","Pondicherry","Haridwar","Thekkady","Guwahati","Nashik","Shillong","Hassan","Bandipur","Jodhpur","Trivandrum","Kumbhalgarh","Mahabaleshwar","Binsar","Baiguney","Vijayawada","Ooty","Shimla","Kullu","Bangalore","Alleppey","Manali","Mumbai","Kollam","Alibaug","Kanha","Hyderabad","Udaipur","Chamba","Naukuchiyatal","Chennai","Pune"]
      flights_header["dep_city_package"] =  package_cities.include?("#{@dep_city_name}") ? true : false
      flights_header["arr_city_package"] =  package_cities.include?("#{@arr_city_name}") ? true : false
      flights_header["dep_featured_city"] = featured_cities.include?("#{@dep_city_name}") ? true : false
      flights_header["arr_featured_city"] = featured_cities.include?("#{@arr_city_name}") ? true : false
      flights_header["dep_city_weekend_getaway"] = weekend_getaway_cities.include?("#{@dep_city_name}") ? true : false
      flights_header["arr_city_weekend_getaway"] = weekend_getaway_cities.include?("#{@arr_city_name}") ? true : false
      flights_header["dep_events_city"] = events_cities.include?("#{@dep_city_name}") ? true : false
      flights_header["arr_events_city"] = events_cities.include?("#{@arr_city_name}") ? true : false
      flights_header["dep_city_things_to_do"] = things_to_do_cities.include?("#{@dep_city_name}") ? true : false
      flights_header["arr_city_things_to_do"] = things_to_do_cities.include?("#{@arr_city_name}") ? true : false
      header_record = Header.find_by(dep_city_code: @dep_city_code,arr_city_code: @arr_city_code)
      hotel_details = eval(header_record.hotel_details) rescue []
      flights_header["near_by_airport_hotels"] = hotel_details["near_by_hotels"].uniq.sample(3) rescue []
      flights_header["hotels_list"] = hotel_details["city_top_hotels"].uniq.take(5) rescue []
      flights_header["hotel_types"] = hotel_details["types_of_hotels"] rescue []
      flights_header["train_details"] = eval(header_record.trains_details) rescue []
      flights_header["hotels_header_list"] = flights_header["hotels_list"].values_at(* flights_header["hotels_list"].each_index.select {|h| h.even?})
      flights_header["hotels_rhs_list"] = flights_header["hotels_list"].values_at(* flights_header["hotels_list"].each_index.select {|h| h.odd?})
      return flights_header      
    end
  	def get_more_routes
      more_routes =  {}
  		more_routes["dep_more_routes"] = UniqueRoute.where(dep_city_code: @dep_city_code).where.not(arr_city_code: @arr_city_code).order("weekly_flights_count desc").pluck(:arr_city_name).uniq.take(30)
  		more_routes["arr_more_routes"] = UniqueRoute.where(arr_city_code: @arr_city_code).where.not(dep_city_code: @dep_city_code).order("weekly_flights_count desc").pluck(:dep_city_name).uniq.take(30)
      return more_routes
  	end

    def get_more_arabic_routes 
      more_routes =  {}
      more_routes["dep_more_routes"] = UniqueRoute.where(dep_city_code: @dep_city_code).where.not(arr_city_code: @arr_city_code).order("weekly_flights_count desc").pluck(:arr_city_code).uniq.take(30).map{|city_code| CityName.find_by(city_code: city_code) rescue "" }
      more_routes["arr_more_routes"] = UniqueRoute.where(arr_city_code: @arr_city_code).where.not(dep_city_code: @dep_city_code).order("weekly_flights_count desc").pluck(:dep_city_code).uniq.take(30).map{|city_code| CityName.find_by(city_code: city_code) rescue "" }
      return more_routes
    end
    def schedule_values(schedule_routes)
      I18n.locale = @language.to_sym
      weekly_flights = PackageFlightSchedule.where(dep_city_code: @route.dep_city_code,arr_city_code: @route.arr_city_code).pluck(:carrier_code)
      weekly_airlines_count = weekly_flights.each_with_object(Hash.new(0)) {|k,v| v[k]+= 1}
      weekly_airlines_count = weekly_airlines_count.map{|k,v| I18n.t("airlines.#{k}") +"#{I18n.t('has')} #{v}"}.to_sentence
      weekly_flights_count = weekly_flights.count
      lang_city_name = "city_name_#{@language.downcase}"
      # airline_count_list = weekly_flights.map{}
      more_routes = @language == "en" ? get_more_routes : get_more_arabic_routes
      min_pr = min_price_new_changes(@dep_city_code,@arr_city_code)
      schedule_routes_with_price = []
      schedule_routes.each do |route|
        route_json = eval(route.to_json)
        route_json[:cc_min_price] = min_pr[:cc][route.carrier_code]
        schedule_routes_with_price << route_json 
      end
      operational_airline_codes = schedule_routes.group_by{|al| al.carrier_code}.map{|k,v| [k,v.count]}.to_h
      operational_airline_names = operational_airline_codes.map{|k,v| I18n.t("airlines.#{k}")}
      airport_details = get_airport_deatils
      @calendar_dates = min_pr[:dt]
        @min30 = min_pr[:cc1]
        @min90 = min_pr[:cc2]
        main_min30 = @min30.values.min{ |a,b| (a["pr"].to_f)<=>(b["pr"].to_f) }  if @min30.values.present?
        main_min90 = @min90.values.min{ |a,b| (a["pr"].to_f)<=>(b["pr"].to_f) }  if @min90.values.present?
      schedule_layout_values = {}
      schedule_layout_values["schedule_routes"] = schedule_routes_with_price
      schedule_layout_values["dep_city_name"] = @route.dep_city_name
      schedule_layout_values["arr_city_name"] = @route.arr_city_name
      schedule_layout_values["dep_city_name_#{@language.downcase}"] = CityName.find_by(city_code: @dep_city_code).send(lang_city_name)
      schedule_layout_values["arr_city_name_#{@language.downcase}"] = CityName.find_by(city_code: @dep_city_code).send(lang_city_name)

      schedule_layout_values["dep_city_name_formated`"] = schedule_airline_values["dep_city_name_formated"]
      schedule_layout_values["arr_city_name_formated"] = schedule_airline_values["arr_city_name_formated"]
      schedule_layout_values["arr_city_name"] = @route.arr_city_name
      schedule_layout_values["dep_city_code"] = @route.dep_city_code
      schedule_layout_values["arr_city_code"] = @route.arr_city_code
      schedule_layout_values["dep_airport_code"] = @route.dep_airport_code
      schedule_layout_values["arr_airport_code"] = @route.arr_airport_code
      schedule_layout_values["section"] = @section
      schedule_layout_values["dep_airport_name"] = Airport.find_by(airport_code: @route.dep_airport_code).airport_name
      schedule_layout_values["arr_airport_name"] = Airport.find_by(airport_code: @route.arr_airport_code).airport_name
      schedule_layout_values["country_code"] = @country_code
      schedule_layout_values["country_name"] = @country_name
      schedule_layout_values["dep_country_code"] = @route.dep_country_code
      schedule_layout_values["arr_country_code"] = @route.arr_country_code
      schedule_layout_values["first_dep_airline"]  =  I18n.t("airlines.#{schedule_routes.first[:carrier_code]}")
      schedule_layout_values["first_dep_airline_no"] = schedule_routes.first[:flight_no]
      schedule_layout_values["first_dep_time"] = Time.strptime(schedule_routes.first[:dep_time],"%H:%M").to_time.strftime("%I:%M %p")
      schedule_layout_values["last_dep_airline"] = I18n.t("airlines.#{schedule_routes.last[:carrier_code]}")
      schedule_layout_values["last_dep_time"]  = Time.strptime(schedule_routes.last[:dep_time],"%H:%M").to_time.strftime("%I:%M %p")
      schedule_layout_values["last_dep_airline_no"] = schedule_routes.last[:flight_no]
      min_max_duration = schedule_routes.collect{|r| r[:duration]}.minmax
      schedule_layout_values["min_duration"] = if min_max_duration[0].include? (":") then min_max_duration[0].to_time.strftime("%Hh %Mm") else Time.at(min_max_duration[0].to_i*60).utc.strftime("%Hh %Mm") end
      schedule_layout_values["max_duration"] = if min_max_duration[1].include? (":") then min_max_duration[1].to_time.strftime("%Hh %Mm") else Time.at(min_max_duration[1].to_i*60).utc.strftime("%Hh %Mm") end
      schedule_layout_values["return_url"]  = schedule_airline_values["return_url"]
      schedule_layout_values["top_dom_airlines"] = schedule_airline_values["top_dom_airlines"]
      schedule_layout_values["top_int_airlines"] = schedule_airline_values["top_int_airlines"]
      schedule_layout_values["distance"] = @route.distance
      schedule_layout_values["weekly_flights_count"] = weekly_flights_count
      schedule_layout_values["operational_airlines"] = operational_airline_names.to_sentence
      schedule_layout_values["operational_airlines_count"] =  operational_airline_names.count
      schedule_layout_values['airline_count_list'] = weekly_airlines_count
      content = fetch_route_content
      schedule_layout_values["dep_city_content"] = content["dep_city_content"]
      schedule_layout_values["arr_city_content"] = content["arr_city_content"]
      schedule_layout_values["unique_route_content"] = content["unique_route_content"] %{airlines_list: schedule_layout_values["operational_airlines"],weekly_flights_count: schedule_layout_values["weekly_flights_count"],airline_count_list: schedule_layout_values["operational_airlines"],first_dep_airline_name: schedule_layout_values["first_dep_airline"],first_dep_time: schedule_layout_values["first_dep_time"],first_dep_flight_no: schedule_layout_values["first_dep_airline_no"],last_dep_flight_no: schedule_layout_values["last_dep_airline_no"],last_dep_airline_name: schedule_layout_values["last_dep_airline"],last_dep_time: schedule_layout_values["last_dep_time"]}
      schedule_layout_values['max_price'] = min_pr[:max]
      schedule_layout_values['route_min_price'] = min_pr[:min]
      schedule_layout_values["min30"] = main_min30
      schedule_layout_values["min90"] = main_min90
      schedule_layout_values["flight_timings"] = @min90
      schedule_layout_values["more_flights_from_dep"] = more_routes["dep_more_routes"]
      schedule_layout_values["more_flights_to_arr"] = more_routes["arr_more_routes"]
      schedule_layout_values["airport_details"] = get_airport_deatils
      return schedule_layout_values
    end
    def schedule_hotel_api_content
      # to get hotel star data , local cities randamized  data and property data from table 
      hotel_api_content = HotelApi.where(city_name: arr_city_name_formated.titleize)
      if hotel_api_content.present?
        api_data  = hotel_api_content.first
        total_local_cities = eval(api_data["local_cities_data"]).count
        current_index = api_data["current_iteration_count"]
        if current_index == 0
          api_data.update(current_iteration_count: current_index+1)
        else
          api_data.update(current_iteration_count: current_index+5)
        end
        if api_data["current_iteration_count"] <= total_local_cities
          if current_index == 0
            local_data_offset = eval(api_data["local_cities_data"]).first(5)
          else
            local_data_offset = eval(api_data["local_cities_data"]).drop(api_data["current_iteration_count"]-5).first(5)
          end
        else
          api_data.update(current_iteration_count: 0)
          local_data_offset = eval(api_data["local_cities_data"]).first(5)
        end
        hotel_api_stars = eval(api_data["star_data"])
        hotel_api_property_types = eval(api_data["properties"])
      end
      #  ending of local cities randamization
    end
    def schedule_footer
        #Foooter links randamization code
        model_name = "#{@country_code.titleize}Footer".constantize
         footer_links = model_name.where(city_code: @dep_city_code)
           if footer_links.present?
            footer_links = footer_links.first
            if footer_links.total_routes_count > 10
              current_index =  footer_links.current_routes_count
              if current_index == 0
                footer_links.update(current_routes_count: current_index+1)
              else
                footer_links.update(current_routes_count: current_index+10)
              end
              if footer_links.current_routes_count <= footer_links.total_routes_count
                if footer_links.current_routes_count == 0 || footer_links.total_routes_count <=10 || footer_links.current_routes_count <= 10
                  footer_links_data = eval(footer_links.routes_data).first(10)
                  footer_links_data_ar = eval(footer_links.routes_data_ar).first(10)
                else
                  footer_links_data = eval(footer_links.routes_data).drop(footer_links.current_routes_count-10).first(10)
                  footer_links_data_ar = eval(footer_links.routes_data_ar).drop(footer_links.current_routes_count-10).first(10)
                end
              else
                footer_links.update(current_routes_count: 0)
                footer_links_data = eval(footer_links.routes_data).first(10)
                footer_links_data_ar = eval(footer_links.routes_data_ar).first(10)

              end
            else
              footer_links_data = eval(footer_links.routes_data)
              footer_links_data_ar = eval(footer_links.routes_data_ar)
            end
            if footer_links_data.count < 5
              footer_links_data = eval(footer_links.routes_data).first(10)
              footer_links_data_ar = eval(footer_links.routes_data_ar).first(10)
            end
            footer_links_data_arabic =[]
            if footer_links_data_ar.count == footer_links_data.count
              footer_links_data.each_with_index  do |u,index|
                if u[:arr_city_name].present? && u[:dep_city_name].present?
                  url ="#{url_escape(u[:dep_city_name])}-#{url_escape(u[:arr_city_name])}-flights.html"
                  arabic_cities =footer_links_data_ar[index]
                  footer_links_data_arabic.push({dep_city_name:arabic_cities[:dep_city_name],arr_city_name:arabic_cities[:arr_city_name],url:url}) if arabic_cities.present?
                end
              end
            end
          end
        dom_airlines = AirlineBrand.where(country_code: @country_code).order("brand_routes_count desc").limit(8).pluck(:carrier_code).uniq
        int_airlines = AirlineBrand.where.not(country_code: @country_code).order("brand_routes_count desc").limit(8).pluck(:carrier_code).uniq
        #Ending of footer randamization code
        return {footer_links_data: footer_links_data,footer_links_data_arabic: footer_links_data_arabic,dom_airlines: dom_airlines,int_airlines: int_airlines}
    end

  def from_to_values(city_code,section)
    city_section = section.include?("from") ? "dep" : "arr"
    dom_flight_route = UniqueRoute.where("#{city_section}_city_code=? and dep_city_code != arr_city_code and arr_city_name != ' ' and dep_city_name != ' ' and  arr_country_code=? and dep_country_code=?", city_code, ENV['COUNTRY'], ENV['COUNTRY']).order("weekly_flights_count desc").limit(10)
    int_flight_route  = UniqueRoute.where("#{city_section}_city_code=? and dep_city_code != arr_city_code and arr_city_name != ' ' and dep_city_name != ' ' and  (arr_country_code!=? or dep_country_code!=?)", city_code, ENV['COUNTRY'], ENV['COUNTRY']).order("weekly_flights_count desc").limit(10)
    routes = {
      "dom"=>[],
      "int"=>[]
    }
    dom_flight_route.each do |route|
      min_price,max_price = get_price(route.dep_city_code,route.arr_city_code)
      pfs_data = PackageFlightSchedule.where("dep_city_name is not null and arr_city_name is not null and dep_city_code=? and arr_city_code=? and carrier_code in (select carrier_code from airline_brands where country_code=?)",route.dep_city_code,route.arr_city_code, ENV['COUNTRY']).order('flight_count desc').limit(1).first
      next unless pfs_data.present?
      carrier_brand = AirlineBrand.find_by({carrier_code: pfs_data.carrier_code})
      if carrier_brand.present? && carrier_brand.carrier_name.present?
        routes["dom"] << {
          "dep_city_name"=> pfs_data.dep_city_name,
          "dep_airport_code"=> pfs_data.dep_airport_code,
          "dep_city_code"=> pfs_data.dep_city_code,
          "dep_city_name_ar" => CityName.find_by(city_code: pfs_data.dep_city_code).city_name_ar,
          "dep_country_code"=> pfs_data.dep_country_code,
          "arr_city_name"=> pfs_data.arr_city_name,
          "arr_city_name_ar" => CityName.find_by(city_code: pfs_data.arr_city_code).city_name_ar,
          "arr_city_code"=> pfs_data.arr_city_code,
          "dep_time"=> Time.parse(pfs_data.dep_time[0...8]).strftime("%0l:%M %p"),
          "arr_time"=> Time.parse(pfs_data.arr_time[0...8]).strftime("%0l:%M %p"),
          "arr_airport_code"=> pfs_data.arr_airport_code,
          "arr_country_code"=> pfs_data.arr_country_code,
          "carrier_code"=> pfs_data.carrier_code,
          "carrier_brand"=> carrier_brand.carrier_name,
          "flight_no"=> pfs_data.flight_no,
          "duration" => pfs_data.elapsed_journey_time,
          "min_price"=> min_price,
          "max_price"=> max_price
        }
      end
    end
    routes["dom"] = routes["dom"].sort {|a,b| a["min_price"] <=> b["min_price"]}
    int_flight_route.each do |route|
      min_price,max_price = get_price(route.dep_city_code,route.arr_city_code)
      pfs_data = PackageFlightSchedule.where("dep_city_name is not null and arr_city_name is not null and dep_city_code=? and arr_city_code=?",route.dep_city_code,route.arr_city_code).order('flight_count desc').limit(1).first
      next unless pfs_data.present?
      carrier_brand = AirlineBrand.find_by({carrier_code: pfs_data.carrier_code})
      if carrier_brand.present? && carrier_brand.carrier_name.present?
        routes["int"] << {
          "dep_city_name"=> pfs_data.dep_city_name,
          "dep_airport_code"=> pfs_data.dep_airport_code,
          "dep_city_code"=> pfs_data.dep_city_code,
          "dep_city_name_ar" => CityName.find_by(city_code: pfs_data.dep_city_code).city_name_ar,
          "dep_country_code"=> pfs_data.dep_country_code,
          "arr_city_name"=> pfs_data.arr_city_name,
          "arr_city_code"=> pfs_data.arr_city_code,
          "arr_city_name_ar" => CityName.find_by(city_code: pfs_data.arr_city_code).city_name_ar,
          "arr_airport_code"=> pfs_data.arr_airport_code,
          "arr_country_code"=> pfs_data.arr_country_code,
          "dep_time"=> Time.parse(pfs_data.dep_time[0...8]).strftime("%0l:%M %p"),
          "arr_time"=> Time.parse(pfs_data.arr_time[0...8]).strftime("%0l:%M %p"),
          "carrier_code"=> pfs_data.carrier_code,
          "carrier_brand"=> carrier_brand.carrier_name,
          "flight_no"=> pfs_data.flight_no,
          "duration" => pfs_data.elapsed_journey_time,
          "min_price"=> min_price,
          "max_price"=> max_price
        }
      end
    end
    routes["int"] = routes["int"].sort {|a,b| a["min_price"] <=> b["min_price"]}
    return routes
  end
  def city_layout_values(city_code, url_section,city_name)
     country_code = @country_code
    if url_section == "from"
      city_section = "dep"
      other_section = "arr"
    else
      city_section = "arr"
      other_section = "dep"
    end
    city_layout_values = {}
    
    airport = Airport.find_by({:city_code=> city_code})
    city_layout_values["dom_airlines"] = schedule_airline_values["top_dom_airlines"]
    city_layout_values["int_airlines"] = schedule_airline_values["top_int_airlines"]
    city_layout_values['airport_name'] = airport.airport_name
    city_layout_values['airport_code'] = airport.airport_code
    city_layout_values['airport_address'] = airport.address
    city_layout_values['airport_phone'] = airport.phone
    city_layout_values['airport_email'] = airport.email
    city_layout_values['airport_web'] = airport.website
    model_name = "#{country_code.titleize}FromToContent".constantize
    city_content = model_name.find_by(city_code: city_code)
    city_layout_values["city_#{url_section}_content"] = city_content.send("#{@language.downcase}_#{url_section}_content") rescue ""
    header_record = Header.find_by(arr_city_code: city_code)
    city_layout_values["arr_city_event"] = header_record.arr_city_event rescue ""
    city_layout_values["arr_city_weekend_getaway"]= header_record.arr_city_weekend_getaway rescue ""
    city_layout_values["arr_city_package"]  = header_record.arr_city_package rescue ""
    city_layout_values["arr_city_featured"] = header_record.arr_city_featured rescue ""
    city_layout_values["arr_city_things_todo"] = header_record.arr_city_things_todo rescue ""
    hotel_details = eval(header_record.hotel_details) rescue []
    city_layout_values["near_by_airport_hotels"] = hotel_details["near_by_hotels"].uniq.sample(3) rescue []
    city_layout_values["hotels_list"] = hotel_details["city_top_hotels"].uniq.take(5) rescue []
    city_layout_values["hotel_types"] = hotel_details["types_of_hotels"] rescue []
    city_layout_values["hotels_header_list"] = city_layout_values["hotels_list"].values_at(* city_layout_values["hotels_list"].each_index.select {|h| h.even?})
    city_layout_values["hotels_rhs_list"] = city_layout_values["hotels_list"].values_at(* city_layout_values["hotels_list"].each_index.select {|h| h.odd?})
    city_layout_values["city_name_formated"] = url_escape(city_name) rescue ""
    lan_city_name = "city_name_#{@language.downcase}"
    country_schedule_model = "#{@country_code.titleize}FlightScheduleCollective".constantize
    sections = ["dom","int"]
    sections.each do |section| 
      query_type = section === "dom" ? "in (?)" : " not in (?) " 
      country_type = section === "dom" ? "country_code=?" : "country_code!=?"
      country_section = section === "dom" ? "(dep_country_code='#{country_code}' and arr_country_code='#{country_code}')" : "NOT(dep_country_code='#{country_code}' and arr_country_code='#{country_code}')"
      top_airlines = country_schedule_model.where("#{city_section}_city_code='#{city_code}' and #{other_section}_city_code!='#{city_code}' and  carrier_code #{query_type} and #{country_section}",@domestic_carrier_codes).group("#{other_section}_city_code")
      city_layout_values["major_#{section}_sectors"] = top_airlines.first(3).map{|r| city_section=="from" ? CityName.find_by(city_code: r.arr_city_code).send(lan_city_name)  : CityName.find_by(city_code: r.dep_city_code).send(lan_city_name) } rescue ""
      top_airlines_cc = top_airlines.map(&:carrier_code).uniq
      city_layout_values["#{section}_airlines_count"] = top_airlines_cc.count
      city_layout_values["#{section}_first_airline"] = I18n.t("airlines.#{top_airlines.first.carrier_code}") rescue ""
      city_layout_values["#{section}_first_dep_time"] = Time.strptime(top_airlines.first.dep_time,"%H:%M").to_time.strftime("%I:%M %p") rescue ""
      city_layout_values["#{section}_last_airline"] = I18n.t("airlines.#{top_airlines.last.carrier_code}") rescue ""
      city_layout_values["#{section}_last_dep_time"] = Time.strptime(top_airlines.last.dep_time,"%H:%M").to_time.strftime("%I:%M %p") rescue ""
      city_layout_values["#{section}_airlines_cc"] = AirlineBrand.where("carrier_code in (?) and country_code=?",top_airlines_cc,@country_code).map(&:carrier_code).take(3)
      airlines_cc = AirlineBrand.where("carrier_code in (?) and #{country_type}",top_airlines_cc,@country_code).map(&:carrier_code).take(3)
      city_layout_values["city_#{section}_airlines"] = airlines_cc.map{|cc| I18n.t("airlines.#{cc}")}.to_sentence rescue ""
      city_layout_values["#{url_section}_more_routes"] = UniqueRoute.where("#{city_section}_city_code='#{city_code}' and #{other_section}_city_code!='#{city_code}'").limit(45)
      city_layout_values["#{section}_route_count"] = UniqueRoute.where("#{city_section}_city_code='#{city_code}' and #{other_section}_city_code!='#{city_code}' and #{country_section}").count
    end
    city_layout_values["major_sectors"] = (city_layout_values["major_dom_sectors"] + city_layout_values["major_int_sectors"]).flatten.shuffle.take(3).to_sentence rescue ""
    return city_layout_values
  end

    def min_price_new_changes(dep_city_code,arr_city_code,carrier_code='')
    result={}
    date_res={}
    result1={}
    data_res_30={}
    min30={}
    max30={}
    min90={}
    max90={}
    max_rate= 0
    max_rate_90= 0
    max_rate_30= 0
    today_date = Date.today
    today = today_date.to_s.split('-').join('')
    next_thirty_days = (today_date + 30).to_s.split('-').join('')
    headers = {"user-agent" => "seo-codingmart"}
    calendar_url = "https://www.cleartrip.com/flights/calendar/calendarstub.json?from=#{dep_city_code}&to=#{arr_city_code}&start_date=#{today}&end_date=#{next_thirty_days}"
    calendar_url_response = HTTParty.get(calendar_url,:headers => headers)
    calendar_data_30 = JSON.parse(calendar_url_response.body.gsub('\"','"')) if calendar_url_response.present? && calendar_url_response.code == 200   rescue ""
    calendar_data_90 = FareCalendar.where({source_city_code: @dep_city_code, destination_city_code: @arr_city_code,:section=>@country_code}).first rescue {}
    if calendar_data_90.present? && calendar_data_90.calendar_json.present? &&  calendar_data_30.present? 
      calendar_json_90 = JSON.parse(calendar_data_90.calendar_json)['calendar_json']
      calendar_json_30 = calendar_data_30['calendar_json']
      calendar_data_90 = calendar_json_90.values.flatten.group_by{|g| g["al"]}
      calendar_data_30 = calendar_json_30.values.flatten.group_by{|g| g["al"]}
      calendar_data_90.take(6).each do |al,rows|
        early_morning=0
        morning=0
        noon=0
        evening=0
        night= 0
        if rows.present?
          rows.each do |val|
            time = val["dt"].to_time
            if time.hour >= 0 && time.hour < 8            
              early_morning += 1
            end
            if time.hour >= 8 && time.hour < 12             
              morning += 1
            end 
            if time.hour >= 12 && time.hour < 16             
              noon += 1
            end 
            if time.hour >= 16 && time.hour < 20             
              evening += 1
            end   
            if time.hour >= 20 && time.hour < 24             
              night += 1
            end           
          end
        end
        result[al] = rows.min{ |a,b| (a["pr"].to_f)<=>(b["pr"].to_f) }["pr"]  if rows.present?
        min90[al] = rows.min{ |a,b| (a["pr"].to_f)<=>(b["pr"].to_f) }  if rows.present?
        min90[al]["emorn"] = early_morning 
        min90[al]["morn"] = morning
        min90[al]["noon"] = noon 
        min90[al]["even"] = evening 
        min90[al]["night"] = night
      end
      calendar_data_90.each do |al,rows|
        result1[al] = rows.max{ |a,b| (a["pr"].to_f)<=>(b["pr"].to_f) }["pr"]  if rows.present?
        max90[al] = rows.max{ |a,b| (a["pr"].to_f)<=>(b["pr"].to_f) }  if rows.present?
      end
      calendar_json_90.each do |date,rows|
        date_res[date] = rows.min{ |a,b| (a["pr"].to_f)<=>(b["pr"].to_f) }["pr"] if rows.present?
      end

      calendar_data_30.each do |al,rows|
        min30[al] = rows.min{ |a,b| (a["pr"].to_f)<=>(b["pr"].to_f) }  if rows.present?
      end
      calendar_data_30.each do |al,rows|
        max30[al] = rows.max{ |a,b| (a["pr"].to_f)<=>(b["pr"].to_f) }  if rows.present?
      end

      min_rate = calendar_json_90.values.flatten.min{ |a,b| (a["pr"].to_f)<=>(b["pr"].to_f) }["pr"] rescue 0
      max_rate = calendar_json_90.values.flatten.max{ |a,b| (a["pr"].to_f)<=>(b["pr"].to_f) }["pr"] rescue 0
      max_rate_90 = calendar_json_90.values.flatten.max{ |a,b| (a["pr"].to_f)<=>(b["pr"].to_f) }["pr"] rescue 0
      max_rate_30 = calendar_json_30.values.flatten.max{ |a,b| (a["pr"].to_f)<=>(b["pr"].to_f) }["pr"] rescue 0
      @no_price = true if max_rate == 0	
    else
      @no_price = true
    end
    return {:cc=>result,:dt=>date_res,:min=>min_rate.to_i,:max=>max_rate.to_i,:cm=>result1,:cc1=>min30,:max1=>max_rate_30,:cm1=>max30,:cc2=>min90,:max2=>max_rate_90,:cm2=>max90}
  end

  def get_price(dep_city_code,arr_city_code,carrier_code='',carrier_name='')
    day_least_rate = {"pr"=>0}
    day_max_rate = {"pr"=>0}
    calendar_data_json = FareCalendar.where({source_city_code: dep_city_code, destination_city_code: arr_city_code, section: @country_code}).first
    if calendar_data_json.present? && calendar_data_json.calendar_json.present?
      calendar_data = JSON.parse(calendar_data_json.calendar_json)['calendar_json'].values.flatten
      if carrier_code.present? 
        cal_data =  calendar_data.group_by{|c| c["al"]}[carrier_code]
        day_least_rate = cal_data.min{|a,b| (a["pr"].to_f)<=>(b["pr"].to_f) } ||  {"pr"=>0} rescue ""
        day_max_rate = cal_data.max{|a,b| (a["pr"].to_f)<=>(b["pr"].to_f)} || {"pr"=>0} rescue ""
      else
        day_least_rate = calendar_data.min{|a,b| (a["pr"].to_f)<=>(b["pr"].to_f) } ||  {"pr"=>0}
        day_max_rate = calendar_data.max{|a,b| (a["pr"].to_f)<=>(b["pr"].to_f)} || {"pr"=>0}
      end
    end

    [day_least_rate["pr"].to_i,day_max_rate["pr"].to_i]
  end

 
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
end