require 'net/http'

class FlightTicketService
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
    @route_type = args[:route_type]
    @domestic_carrier_codes = AirlineBrand.where(country_code: @country_code).pluck("distinct(carrier_code)") 
  end

  def ticket_airline_values
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

  # def fetch_route_content
  # 	content = {"unique_route_content" => "",
  # 				"dep_city_content" => "",
  # 				"arr_city_content" => ""}
  # 	if I18n.t("flight_schedule_content.#{@country_code.downcase}.#{@dep_city_name}-#{@arr_city_name}-Flights").index("translation missing").nil? 
  # 		unique_route_content = I18n.t("flight_schedule_content.#{@dep_city_name}-#{@arr_city_name}-Flights")
  # 		content["unique_route_content"] = unique_route_content 
  # 	else
  # 		dep_city = CityContent.find_by(city_code: @dep_city_code)
  # 		arr_city = CityContent.find_by(city_code: @arr_city_code)
  # 		country_code = @country_code.downcase
  # 		language = @language.downcase
  # 		country_lang = "content_"+"#{@country_code.downcase}_#{@language.downcase}"
  # 		content["dep_city_content"]= dep_city.send(country_lang) rescue nil
  # 		content["arr_city_content"] = arr_city.send(country_lang)	rescue nil
  # 	end
  # 	return content
  # end

  def get_airport_details
    airport_details = {}
  	@airports = Hash[Airport.where(:city_code=>[@dep_city_code,@arr_city_code]).map{|c| [c.city_code,c]}]
    airport_details['dep_airport_name'] = @airports[@dep_city_code].airport_name rescue ""
    airport_details['arr_airport_name'] = @airports[@arr_city_code].airport_name rescue ""
    airport_details['dep_airport_name_ar'] = @airports[@dep_city_code].airport_name_ar rescue ""
    airport_details['arr_airport_name_ar'] = @airports[@arr_city_code].airport_name_ar rescue ""
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

	def ticket_header_details 
    flights_header = {}  
    hop  =  @route_type == "non-stop" ? '' : "Hop"
    model_name = "PackageFlight#{hop}Schedule".constantize
    top_dom_cc = AirlineBrand.where(country_code: @country_code).order("brand_routes_count desc").limit(8).pluck(:carrier_code)
    route_dom_airlines = model_name.where(dep_city_code: @dep_city_code,arr_city_code: @arr_city_code,carrier_code: top_dom_cc).pluck(:carrier_code).uniq
    route_int_airlines = model_name.where(dep_city_code: @dep_city_code,arr_city_code: @arr_city_code).where.not(carrier_code: top_dom_cc).pluck(:carrier_code).uniq
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
    model_name = "#{@country_code.titleize}VolumeRoute".constantize
    more_routes =  {}
    more_routes["dep_more_routes"] = model_name.where(dep_city_code: @dep_city_code).where.not(arr_city_code: @arr_city_code).take(30)
    more_routes["arr_more_routes"] = model_name.where(arr_city_code: @arr_city_code).where.not(dep_city_code: @dep_city_code).take(30)
       return more_routes
	end

  # def get_more_arabic_routes 
  #   hop = @route_type == "one-hop" ? 'Hop' : ''
  #   model_name = "Unique#{hop}Route".constantize
  #   more_routes =  {}
  #   more_routes["dep_more_routes"] = model_name.where(dep_city_code: @dep_city_code).where.not(arr_city_code: @arr_city_code).order("weekly_flights_count desc").pluck(:arr_city_code).uniq.take(30).map{|city_code| CityName.find_by(city_code: city_code) rescue "" }
  #   more_routes["arr_more_routes"] = model_name.where(arr_city_code: @arr_city_code).where.not(dep_city_code: @dep_city_code).order("weekly_flights_count desc").pluck(:dep_city_code).uniq.take(30).map{|city_code| CityName.find_by(city_code: city_code) rescue "" }
  #   return more_routes
  # end
  def ticket_footer
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
  def ticket_values(ticket_routes)
    I18n.locale = @language.to_sym
    weekly_flights = PackageFlightSchedule.where(dep_city_code: @route.dep_city_code,arr_city_code: @route.arr_city_code).pluck(:carrier_code)
    weekly_airlines_count = weekly_flights.each_with_object(Hash.new(0)) {|k,v| v[k]+= 1}
    weekly_airlines_count = weekly_airlines_count.map{|k,v| I18n.t("airlines.#{k}") +" #{I18n.t('has')} #{v} "}
    weekly_airlines_count = @language == "ar" ? weekly_airlines_count.to_sentence(last_word_connector: "و") : weekly_airlines_count.to_sentence
    weekly_flights_count = weekly_flights.count
    lang_city_name = "city_name_#{@language.downcase}"
    # airline_count_list = weekly_flights.map{}
    flight_schedule_service = FlightScheduleService.new
    more_routes = get_more_routes 
    min_pr = min_price_new_changes(@dep_city_code,@arr_city_code)
    ticket_routes_with_price = []
    ticket_routes.each do |route|
      route_json = eval(route.to_json)
      route_json[:cc_min_price] = min_pr[:cc][route.carrier_code]
      ticket_routes_with_price << route_json 
    end
    operational_airline_codes = ticket_routes.group_by{|al| al.carrier_code}.map{|k,v| [k,v.count]}.to_h
    operational_individual_ailine_count = operational_airline_codes
    operational_airline_names = operational_airline_codes.map{|k,v| I18n.t("airlines.#{k}")}
    @calendar_dates = min_pr[:dt]
      @min30 = min_pr[:cc1]
      @min90 = min_pr[:cc2]
      main_min30 = @min30.values.min{ |a,b| (a["pr"].to_f)<=>(b["pr"].to_f) }  if @min30.values.present?
      main_min90 = @min90.values.min{ |a,b| (a["pr"].to_f)<=>(b["pr"].to_f) }  if @min90.values.present?
    ticket_layout_values = {}
    ticket_layout_values["ticket_routes"] = ticket_routes_with_price
    ticket_layout_values["dep_city_name"] = @route.dep_city_name
    ticket_layout_values["arr_city_name"] = @route.arr_city_name
    ticket_layout_values["dep_city_name_#{@language.downcase}"] = CityName.find_by(city_code: @dep_city_code).send(lang_city_name)
    ticket_layout_values["arr_city_name_#{@language.downcase}"] = CityName.find_by(city_code: @dep_city_code).send(lang_city_name)
    ticket_layout_values["dep_city_name_formated"] = ticket_airline_values["dep_city_name_formated"]
    ticket_layout_values["arr_city_name_formated"] = ticket_airline_values["arr_city_name_formated"]
    ticket_layout_values["arr_city_name"] = @route.arr_city_name
    ticket_layout_values["dep_city_code"] = @route.dep_city_code
    ticket_layout_values["arr_city_code"] = @route.arr_city_code
    ticket_layout_values["dep_airport_code"] = @route.dep_airport_code
    ticket_layout_values["arr_airport_code"] = @route.arr_airport_code
    ticket_layout_values["section"] = @section
    dep_airport = Airport.find_by(airport_code: @route.dep_airport_code)
    arr_airport = Airport.find_by(airport_code: @route.arr_airport_code)
    ticket_layout_values["dep_airport_name"] = dep_airport.airport_name
    ticket_layout_values["arr_airport_name"] = arr_airport.airport_name
    ticket_layout_values["dep_airport_name_ar"] = dep_airport.airport_name_ar
    ticket_layout_values["arr_airport_name_ar"] = arr_airport.airport_name_ar
    ticket_layout_values["country_code"] = @country_code
    ticket_layout_values["country_name"] = @country_name
    ticket_layout_values["dep_country_code"] = @route.dep_country_code
    ticket_layout_values["arr_country_code"] = @route.arr_country_code
    ticket_layout_values["first_dep_airline"]  =  I18n.t("airlines.#{ticket_routes.first[:carrier_code]}") rescue ""
    ticket_layout_values["first_dep_airline_no"] = ticket_routes.first[:flight_no] rescue ""
    ticket_layout_values["first_dep_time"] = Time.strptime(ticket_routes.first[:dep_time],"%H:%M").to_time.strftime("%I:%M %p") rescue ""
    ticket_layout_values["last_dep_airline"] = I18n.t("airlines.#{ticket_routes.last[:carrier_code]}") rescue ""
    ticket_layout_values["last_dep_time"]  = Time.strptime(ticket_routes.last[:dep_time],"%H:%M").to_time.strftime("%I:%M %p") rescue ""
    ticket_layout_values["last_dep_airline_no"] = ticket_routes.last[:flight_no] rescue ""
    min_max_duration = ticket_routes.collect{|r| r[:duration]}.minmax rescue ["",""]
    ticket_layout_values["min_duration"] = if min_max_duration[0].include? (":") then min_max_duration[0].to_time.strftime("%Hh %Mm") else Time.at(min_max_duration[0].to_i*60).utc.strftime("%Hh %Mm") end
    ticket_layout_values["max_duration"] = if min_max_duration[1].include? (":") then min_max_duration[1].to_time.strftime("%Hh %Mm") else Time.at(min_max_duration[1].to_i*60).utc.strftime("%Hh %Mm") end
    ticket_layout_values["return_url"]  = ticket_airline_values["return_url"]
    ticket_layout_values["top_dom_airlines"] = ticket_airline_values["top_dom_airlines"] 
    ticket_layout_values["top_int_airlines"] = ticket_airline_values["top_int_airlines"]
    ticket_layout_values["distance"] = @route.distance 
    ticket_layout_values["weekly_flights_count"] = weekly_flights_count
    ticket_layout_values["operational_airlines"] = @language=="ar" ? operational_airline_names.to_sentence(:last_word_connector=> "و") : operational_airline_names.to_sentence
    ticket_layout_values["operational_airlines_count"] =  operational_airline_names.count
    ticket_layout_values['airline_count_list'] =  weekly_airlines_count 
    # content = fetch_route_content
    # ticket_layout_values["dep_city_content"] = content["dep_city_content"]
    # ticket_layout_values["arr_city_content"] = content["arr_city_content"]
    # ticket_layout_values["unique_route_content"] = content["unique_route_content"] %{airlines_list: ticket_layout_values["operational_airlines"],weekly_flights_count: ticket_layout_values["weekly_flights_count"],airline_count_list: ticket_layout_values["operational_airlines"],first_dep_airline_name: ticket_layout_values["first_dep_airline"],first_dep_time: ticket_layout_values["first_dep_time"],first_dep_flight_no: ticket_layout_values["first_dep_airline_no"],last_dep_flight_no: ticket_layout_values["last_dep_airline_no"],last_dep_airline_name: ticket_layout_values["last_dep_airline"],last_dep_time: ticket_layout_values["last_dep_time"]}
    ticket_layout_values['max_price'] = min_pr[:max]
    ticket_layout_values['route_min_price'] = min_pr[:min]
    ticket_layout_values["min30"] = main_min30
    ticket_layout_values["min90"] = main_min90
    ticket_layout_values["flight_timings"] = @min90
    ticket_layout_values["more_flights_from_dep"] = more_routes["dep_more_routes"]
    ticket_layout_values["more_flights_to_arr"] = more_routes["arr_more_routes"]
    ticket_layout_values["airport_details"] = get_airport_details
    return ticket_layout_values
  end

  def ticket_hop_values(ticket_routes)
    I18n.locale = @language.to_sym
    weekly_flights = PackageFlightHopSchedule.where(dep_city_code: @route.dep_city_code,arr_city_code: @route.arr_city_code).pluck(:carrier_code)
    weekly_airlines_count = weekly_flights.each_with_object(Hash.new(0)) {|k,v| v[k]+= 1}
    weekly_airlines_count = weekly_airlines_count.map{|k,v| I18n.t("airlines.#{k}") +"#{I18n.t('has')} #{v}"}.to_sentence
    weekly_flights_count = weekly_flights.count
    lang_city_name = "city_name_#{@language.downcase}"
    # airline_count_list = weekly_flights.map{}
    more_routes = get_more_routes  
    min_pr = min_price_new_changes(@dep_city_code,@arr_city_code)
    operational_airline_codes = ticket_routes.group_by{|al| al.carrier_code}.map{|k,v| [k,v.count]}.to_h rescue ""
    operational_airline_names = operational_airline_codes.map{|k,v| I18n.t("airlines.#{k}")}  rescue ""
    ticket_layout_hop_values = {}
    ticket_layout_hop_values["ticket_routes"] = ticket_routes
    ticket_layout_hop_values["dep_city_name"] = @route.dep_city_name
    ticket_layout_hop_values["arr_city_name"] = @route.arr_city_name
    ticket_layout_hop_values["dep_city_name_#{@language.downcase}"] = CityName.find_by(city_code: @dep_city_code).send(lang_city_name)
    ticket_layout_hop_values["arr_city_name_#{@language.downcase}"] = CityName.find_by(city_code: @dep_city_code).send(lang_city_name)
    ticket_layout_hop_values["dep_city_name_formated"] = ticket_airline_values["dep_city_name_formated"]
    ticket_layout_hop_values["arr_city_name_formated"] = ticket_airline_values["arr_city_name_formated"]
    ticket_layout_hop_values["arr_city_name"] = @route.arr_city_name
    ticket_layout_hop_values["dep_city_code"] = @route.dep_city_code
    ticket_layout_hop_values["arr_city_code"] = @route.arr_city_code
    ticket_layout_hop_values["dep_airport_code"] = @route.dep_airport_code
    ticket_layout_hop_values["arr_airport_code"] = @route.arr_airport_code
    ticket_layout_hop_values["section"] = @section
     dep_airport = Airport.find_by(airport_code: @route.dep_airport_code)
    arr_airport = Airport.find_by(airport_code: @route.arr_airport_code)
    ticket_layout_hop_values["dep_airport_name"] = dep_airport.airport_name
    ticket_layout_hop_values["arr_airport_name"] = arr_airport.airport_name
    ticket_layout_hop_values["dep_airport_name_ar"] = dep_airport.airport_name_ar
    ticket_layout_hop_values["arr_airport_name_ar"] = arr_airport.airport_name_ar
    ticket_layout_hop_values["country_code"] = @country_code
    ticket_layout_hop_values["country_name"] = @country_name
    ticket_layout_hop_values["dep_country_code"] = @route.dep_country_code
    ticket_layout_hop_values["arr_country_code"] = @route.arr_country_code
    ticket_layout_hop_values["first_dep_airline"]  =  I18n.t("airlines.#{ticket_routes.first[:carrier_code]}") rescue ""
    ticket_layout_hop_values["first_dep_airline_no"] = ticket_routes.first[:flight_no] rescue ""
    ticket_layout_hop_values["first_dep_time"] = Time.strptime(ticket_routes.first[:dep_time],"%H:%M").to_time.strftime("%I:%M %p") rescue ""
    ticket_layout_hop_values["last_dep_airline"] = I18n.t("airlines.#{ticket_routes.last[:carrier_code]}") rescue ""
    ticket_layout_hop_values["last_dep_time"]  = Time.strptime(ticket_routes.last[:dep_time],"%H:%M").to_time.strftime("%I:%M %p") rescue ""
    ticket_layout_hop_values["last_dep_airline_no"] = ticket_routes.last[:flight_no] rescue ""
    min_max_duration = ticket_routes.collect{|r| r[:duration]}.minmax rescue ""
    ticket_layout_hop_values["min_duration"] = if min_max_duration[0].include? (":") then min_max_duration[0].to_time.strftime("%Hh %Mm") else Time.at(min_max_duration[0].to_i*60).utc.strftime("%Hh %Mm") end rescue ""
    ticket_layout_hop_values["max_duration"] = if min_max_duration[1].include? (":") then min_max_duration[1].to_time.strftime("%Hh %Mm") else Time.at(min_max_duration[1].to_i*60).utc.strftime("%Hh %Mm") end rescue ""
    ticket_layout_hop_values["return_url"]  = ticket_airline_values["return_url"]
    ticket_layout_hop_values["top_dom_airlines"] = ticket_airline_values["top_dom_airlines"]
    ticket_layout_hop_values["top_int_airlines"] = ticket_airline_values["top_int_airlines"]
    ticket_layout_hop_values["distance"] = @route.distance
    ticket_layout_hop_values["weekly_flights_count"] = weekly_flights_count
    ticket_layout_hop_values["operational_airlines"] = operational_airline_names.to_sentence rescue []
    ticket_layout_hop_values["operational_airlines_count"] =  operational_airline_names.count rescue ""
    ticket_layout_hop_values['airline_count_list'] = weekly_airlines_count
    # content = fetch_route_content
    # ticket_layout_hop_values["dep_city_content"] = content["dep_city_content"]
    # ticket_layout_hop_values["arr_city_content"] = content["arr_city_content"]
    # ticket_layout_hop_values["unique_route_content"] = content["unique_route_content"] %{airlines_list: ticket_layout_hop_values["operational_airlines"],weekly_flights_count: ticket_layout_hop_values["weekly_flights_count"],airline_count_list: ticket_layout_hop_values["operational_airlines"],first_dep_airline_name: ticket_layout_hop_values["first_dep_airline"],first_dep_time: ticket_layout_hop_values["first_dep_time"],first_dep_flight_no: ticket_layout_hop_values["first_dep_airline_no"],last_dep_flight_no: ticket_layout_hop_values["last_dep_airline_no"],last_dep_airline_name: ticket_layout_hop_values["last_dep_airline"],last_dep_time: ticket_layout_hop_values["last_dep_time"]}
    ticket_layout_hop_values["more_flights_from_dep"] = more_routes["dep_more_routes"]
    ticket_layout_hop_values["more_flights_to_arr"] = more_routes["arr_more_routes"]
    ticket_layout_hop_values["airport_details"] = get_airport_details
    return ticket_layout_hop_values
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