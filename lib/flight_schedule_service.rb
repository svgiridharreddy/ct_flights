require_relative './support/constants.rb'
require 'net/http'

class FlightScheduleService
	def initialize(args)
	    @dep_city_code = args[:dep_city_code]
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
    	route_values = {}
    	dep_city_name_formated = url_escape(@dep_city_name)
    	arr_city_name_formated = url_escape(@arr_city_name)
    	return_url = arr_city_name_formated +"-"+dep_city_name_formated +"-flights.html"
			top_dom_cc = AirlineBrand.where(country_code: @country_code).order("brand_routes_count desc").limit(8).pluck(:carrier_code)
			top_dom_airlines = top_dom_cc.map{|cc| I18n.t("airlines.#{cc}")}
			top_int_cc = AirlineBrand.where.not(country_code: @country_code).order("brand_routes_count desc").limit(8).pluck(:carrier_code)
			top_int_airlines = top_int_cc.map{|cc| I18n.t("airlines.#{cc}") } 
			route_values["return_url"] = return_url
			route_values["dep_city_name_formated"] = dep_city_name_formated
			route_values["arr_city_name_formated"] = arr_city_name_formated
			route_values["top_dom_airlines"] = top_dom_cc
			route_values["top_int_airlines"] = top_int_cc
			return route_values
    end
    def fetch_route_content
    	content = {"unique_route_content" => "",
    				"dep_city_content" => "",
    				"arr_city_content" => ""}
    	
    	if I18n.t("flight_schedule_content.#{@dep_city_name}-#{@arr_city_name}-Flights").index("translation missing").nil? 
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
      arr_city_weekend_getaway = false
      arr_featured_city = false
      arr_city_package = false
      arr_events_city = false
      events_cities = ["Bangalore","Mumbai","Hyderabad","New Delhi"]
      weekend_getaway_cities = ["Agra", "Bhopal", "Goa", "Dehradun", "Ahmedabad", "Jammu", "Patna", "Kochi", "New Delhi", "Coorg", "Bangalore", "Mumbai", "Udaipur", "Chennai", "Pune"]
      featured_cities  =  ["Agra", "Gangtok", "Bhopal", "Goa", "Chandigarh", "Amritsar", "Gurgaon", "Dehradun", "Wayanad", "Ahmedabad", "Kolkata", "Kochi", "Jaipur", "Thekkady", "New Delhi", "Coorg", "Kullu", "Bangalore", "Alleppey", "Manali", "Mumbai", "Lucknow", "Hyderabad", "Indore", "Chennai", "Pune"]
      package_cities = ["Dehradun","Ahmedabad","Vijayawada","Rajkot","Belgaum","Leh","Mangalore","Vadodara","Mumbai","Lucknow","Madurai","Goa","Guwahati","Indore","Jaipur","Calicut","Tiruchirappally","Port Blair","Aizawl","Udaipur","Cochin","Raipur","Visakhapatnam","Hyderabad","Coimbatore","Khajuraho","Kullu Manali","Porbandar","Bhopal","Agra","Bangalore","Pune","Kanpur","Ranchi","Jorhat","Visakhapatnam","Mysore","Ranchi","Jodhpur","Dharamsala","Ludhiana","New Delhi","Agartala","Diu","Pantnagar","Bhubaneswar","Srinagar","Jammu","Patna","Hubli","Aurangabad","Shillong","Allahabad","Surat","Imphal","Jabalpur","Kolkata","Trivandrum","Chandigarh","Rajahmundry","Nagpur","Dibrugarh","Varanasi","Bhavnagar","Bhuj","Chennai","Amritsar","Jamnagar","Gwalior","Tirupati","Gorakhpur"]
        flights_header["arr_city_package"] =  package_cities.include?("#{@arr_city_name}") ? true : false
        flights_header["arr_featured_city"] = featured_cities.include?("#{@arr_city_name}") ? true : false
        flights_header["arr_city_weekend_getaway"] = weekend_getaway_cities.include?("#{@arr_city_name}") ? true : false
        flights_header["arr_events_city"] = events_cities.include?("#{@arr_city_name}") ? true : false
        header_record = FlightsHeader.find_by(dep_city_code: @dep_city_code,arr_city_code: @arr_city_code)

        hotel_details = eval(header_record.hotel_details) rescue []
        flights_header["near_by_airport_hotels"] = hotel_details["near_by_hotels"].uniq.sample(3) rescue []
        flights_header["hotels_list"] = hotel_details["city_top_hotels"].uniq.take(5) rescue []
        flights_header["hotel_types"] = hotel_details["types_of_hotels"] rescue []
        flights_header["train_details"] = eval(header_record.train_details) rescue []
        flights_header["hotels_header_list"] = flights_header["hotels_list"].values_at(* flights_header["hotels_list"].each_index.select {|h| h.even?})
        flights_header["hotels_rhs_list"] = flights_header["hotels_list"].values_at(* flights_header["hotels_list"].each_index.select {|h| h.odd?})
      return flights_header      
    end
  	def get_more_routes
      more_routes =  {}
  		more_routes["dep_more_routes"] = PackageFlightSchedule.where(dep_city_code: @dep_city_code).where.not(arr_city_code: @arr_city_code).order("flight_count desc").pluck(:arr_city_name).uniq.take(30)
  		more_routes["arr_more_routes"] = PackageFlightSchedule.where(arr_city_code: @arr_city_code).where.not(dep_city_code: @dep_city_code).order("flight_count desc").pluck(:dep_city_name).uniq.take(30)
  		return more_routes
      
  	end
    def schedule_values(schedule_routes)
     
      weekly_flights = PackageFlightSchedule.where(dep_city_code: @route.dep_city_code,arr_city_code: @route.arr_city_code).pluck(:carrier_code)
      weekly_airlines_count = weekly_flights.each_with_object(Hash.new(0)) {|k,v| v[k]+= 1}
      weekly_airlines_count = weekly_airlines_count.map{|k,v| I18n.t("airlines.#{k}") +"has #{v}"}.to_sentence
      weekly_flights_count = weekly_flights.count
      # airline_count_list = weekly_flights.map{}
      more_routes = get_more_routes
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
      schedule_layout_values["dep_city_name_formated"] = schedule_airline_values["dep_city_name_formated"]
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
      schedule_layout_values["unique_route_content"] = content["unique_route_content"] %{airlines_list: schedule_layout_values["operational_airlines"],weekly_flights_count: schedule_layout_values["weekly_flights_count"],airline_count_list: schedule_layout_values["operational_airlines"],first_dep_airline_name: schedule_layout_values["first_dep_airline"],first_dep_time: schedule_layout_values["first_dep_time"],last_dep_airline_name: schedule_layout_values["last_dep_airline"],last_dep_time: schedule_layout_values["last_dep_time"]}
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
    calendar_data_30 = JSON.parse(calendar_url_response.body.gsub('\"','"')) if calendar_url_response.present? && calendar_url_response.code == 200    
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