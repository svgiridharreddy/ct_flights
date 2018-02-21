class FlightSchedulesController < ApplicationController

	def schedule_values
		domain = request.domain
		url = request.original_url
				binding.pry

		@country_code = host_name(domain)[0]
		# @country_code = 'IN'
		@country_name = host_name(domain)[1]
		# @country_name = 'India'
		@dep_city_name  = params[:dep_city_name].titleize
		@arr_city_name = params[:arr_city_name].titleize
		@language = params[:lang].nil? ? 'en' : params[:lang]
		@route = UniqueRoute.find_by(dep_city_name: @dep_city_name,arr_city_name: @arr_city_name)
		# @route_type = @route.hop == 0 ? "direct" : "hop"
		# binding.pry
		@route_type = "direct"
		if @route.dep_country_code == @country_code &&  @route.arr_country_code == @country_code
			@section = @country_code + "-dom"
		else
			@section = @country_code + "-int"
		end
		
		@route_details =  { :dep_city_code => @route.dep_city_code,
											  :arr_city_code => @route.arr_city_code,
											  :dep_airport_code => @route.dep_airport_code,
											  :arr_airport_code => @route.arr_airport_code,
											  :dep_country_code => @route.dep_country_code,
												:arr_country_code => @route.arr_country_code,
												:dep_city_name => @dep_city_name,
												:arr_city_name => @arr_city_name,
												:country_code => @country_code,
												:section => @section,
												:language => @language,
												:route => @route,
												:route_type => @route_type,
												:country_name => @country_name }

		flight_schedule_service = FlightScheduleService.new @route_details	 
		@domestic_carrier_codes = AirlineBrand.where(country_code: @country_code).pluck("distinct(carrier_code)")
		@all_carrier_codes = AirlineBrand.all.pluck(:carrier_code)

		unless (@section.include? "int")
      inc_cc = "carrier_code in ('#{@domestic_carrier_codes.join("\',\'")}')"
    else
      inc_cc =  "carrier_code in ('#{@all_carrier_codes.join("\',\'")}')"
    end
		@schedule_routes = @route.flight_schedule_collectives.where("#{inc_cc}").order("dep_time asc").limit(10)
		schedule_layout_values = flight_schedule_service.schedule_values(@schedule_routes)
		if @section.include? ("dom") 
			partial = "flight_schedule_routes/#{@language}/flight_schedule_dom_#{@language.downcase}_#{@country_code.downcase}"
		else
			partial = "flight_schedule_routes/#{@language}/flight_schedule_int_#{@language.downcase}_#{@country_code.downcase}"
		end
		render  partial,locals: {schedule_layout_values: schedule_layout_values,dep_city_name: @dep_city_name,arr_city_name: @arr_city_name,dep_city_code: @dep_city_code,arr_city_code: @arr_city_code }
	end


	def host_name(host)
		# host = host || ""
    # puts "country_code - #{country_code}"
    if host == 'http://54.169.165.81'
    	return ['IN',"India"]
    elsif host == 'https://www.cleartrip.ae'
      return ['AE',"United Arab Emirates"]
    elsif host == 'https://kw.cleartrip.com'
      return ['KW',"Kuwait"]
    elsif host == 'https://www.cleartrip.sa'
      return ['SA',"Saudi Arabia"]
    elsif host == 'https://bh.cleartrip.com'
      return ['BH',"Bahrain"]
    elsif host == 'https://qa.cleartrip.com'
      return ['QA',"Qatar"]
    elsif host == 'https://om.cleartrip.com'
      return ['OM',"Oman"]
    elsif host == 'https://www.cleartrip.com'
      return ['IN',"India"]
    else
      ''
    end
  end
	
end

# just for reference --- earlier it was in controller method and now moved to service.

  # def schedule_values_refernce
  # weekly_flights = PackageFlightSchedule.where(dep_city_code: @route.dep_city_code,arr_city_code: @route.arr_city_code).pluck(:carrier_code)
		# weekly_airlines_count = weekly_flights.each_with_object(Hash.new(0)) {|k,v| v[k]+= 1}
		# weekly_airlines_count = weekly_airlines_count.map{|k,v| t("airlines.#{k}") +"has #{v}"}.to_sentence
		# weekly_flights_count = weekly_flights.count
		# # airline_count_list = weekly_flights.map{}
		
		# more_routes = flight_schedule_service.get_more_routes
		# min_pr = flight_schedule_service.min_price_new_changes(@dep_city_code,@arr_city_code)
		# schedule_routes = []
		# @schedule_routes.each do |route|
		# 	route_json = eval(route.to_json)
		# 	route_json[:cc_min_price] = min_pr[:cc][route.carrier_code]
		# 	schedule_routes << route_json	
		# end
		# operational_airline_codes = @schedule_routes.group_by{|al| al.carrier_code}.map{|k,v| [k,v.count]}.to_h
		# operational_airline_names = operational_airline_codes.map{|k,v| I18n.t("airlines.#{k}")}
		# airport_details = flight_schedule_service.get_airport_deatils
		# min_pr = flight_schedule_service.min_price_new_changes(@dep_city_code,@arr_city_code)
		# @calendar_dates = min_pr[:dt]
  #   	@min30 = min_pr[:cc1]
  #   	@min90 = min_pr[:cc2]
  #   	main_min30 = @min30.values.min{ |a,b| (a["pr"].to_f)<=>(b["pr"].to_f) }  if @min30.values.present?
  #   	main_min90 = @min90.values.min{ |a,b| (a["pr"].to_f)<=>(b["pr"].to_f) }  if @min90.values.present?
		# schedule_layout_values = {}
		# schedule_layout_values["schedule_routes"] = schedule_routes
		# schedule_layout_values["dep_city_name"] = @route.dep_city_name
		# schedule_layout_values["arr_city_name"] = @route.arr_city_name
		# schedule_layout_values["dep_city_name_formated"] = flight_schedule_service.schedule_layout_values["dep_city_name_formated"]
		# schedule_layout_values["arr_city_name_formated"] = flight_schedule_service.schedule_layout_values["arr_city_name_formated"]
		# schedule_layout_values["arr_city_name"] = @route.arr_city_name
		# schedule_layout_values["dep_city_code"] = @route.dep_city_code
		# schedule_layout_values["arr_city_code"] = @route.arr_city_code
		# schedule_layout_values["dep_airport_code"] = @route.dep_airport_code
		# schedule_layout_values["arr_airport_code"] = @route.arr_airport_code
		# schedule_layout_values["dep_airport_name"] = Airport.find_by(airport_code: @route.dep_airport_code).airport_name
		# schedule_layout_values["arr_airport_name"] = Airport.find_by(airport_code: @route.arr_airport_code).airport_name
		# schedule_layout_values["country_code"] = @country_code
		# schedule_layout_values["country_name"] = country_name
		# schedule_layout_values["dep_country_code"] = @route.dep_country_code
		# schedule_layout_values["arr_country_code"] = @route.arr_country_code
		# schedule_layout_values["first_dep_airline"]  =  I18n.t("airlines.#{@schedule_routes.first[:carrier_code]}")
		# schedule_layout_values["first_dep_airline_no"] = @schedule_routes.first[:flight_no]
		# schedule_layout_values["first_dep_time"] = Time.strptime(@schedule_routes.first[:dep_time],"%H:%M").to_time.strftime("%I:%M %p")
		# schedule_layout_values["last_dep_airline"] = I18n.t("airlines.#{@schedule_routes.last[:carrier_code]}")
		# schedule_layout_values["last_dep_time"]  = Time.strptime(@schedule_routes.last[:dep_time],"%H:%M").to_time.strftime("%I:%M %p")
		# schedule_layout_values["last_dep_airline_no"] = @schedule_routes.last[:flight_no]
		# min_max_duration = @schedule_routes.collect{|r| r[:duration]}.minmax
		# schedule_layout_values["min_duration"] = if min_max_duration[0].include? (":") then min_max_duration[0].to_time.strftime("%Hh %Mm") else Time.at(min_max_duration[0].to_i*60).utc.strftime("%Hh %Mm") end
		# schedule_layout_values["max_duration"] = if min_max_duration[1].include? (":") then min_max_duration[1].to_time.strftime("%Hh %Mm") else Time.at(min_max_duration[1].to_i*60).utc.strftime("%Hh %Mm") end
		# binding.pry
		# schedule_layout_values["return_url"]  = flight_schedule_service.schedule_layout_values["return_url"]
		# schedule_layout_values["top_dom_airlines"] = flight_schedule_service.schedule_layout_values["top_dom_airlines"]
		# schedule_layout_values["top_int_airlines"] = flight_schedule_service.schedule_layout_values["top_int_airlines"]
		# schedule_layout_values["distance"] = @route.distance
		# schedule_layout_values["weekly_flights_count"] = weekly_flights_count
		# schedule_layout_values["operational_airlines"] = operational_airline_names.to_sentence
		# schedule_layout_values["operational_airlines_count"] =  operational_airline_names.count
		# schedule_layout_values['airline_count_list'] = weekly_airlines_count
		# content = flight_schedule_service.fetch_route_content
		# schedule_layout_values["dep_city_content"] = content["dep_city_content"]
		# schedule_layout_values["arr_city_content"] = content["arr_city_content"]
		# schedule_layout_values["unique_route_content"] = content["unique_route_content"] %{airlines_list: schedule_layout_values["operational_airlines"],weekly_flights_count: schedule_layout_values["weekly_flights_count"],airline_count_list: schedule_layout_values["operational_airlines"],first_dep_airline_name: schedule_layout_values["first_dep_airline"],first_dep_time: schedule_layout_values["first_dep_time"],last_dep_airline_name: schedule_layout_values["last_dep_airline"],last_dep_time: schedule_layout_values["last_dep_time"]}
  #   	schedule_layout_values['max_price'] = min_pr[:max]
  #   	schedule_layout_values['route_min_price'] = min_pr[:min]
  #   	schedule_layout_values["min30"] = main_min30
  #   	schedule_layout_values["min90"] = main_min90
  #   	schedule_layout_values["flight_timings"] = @min90
  #   # schedule_layout_values["no_price"] = @no_price
  # end