class FlightSchedulesController < ApplicationController

	def schedule_values
		domain = request.domain
		ulr = request.original_url
		@country_code = host_name(domain)[0]
		country_name = host_name(domain)[1]
		@dep_city_name  = params[:dep_city_name].titleize
		@arr_city_name = params[:arr_city_name].titleize
		@language = params[:lang].nil? ? 'en' : params[:lang]
		# unless params[:lang].nil?
		# 	@language = params[:lang]
		# else
		# 	@language = 'en'
		# end
		@route = UniqueRoute.find_by(dep_city_name: @dep_city_name,arr_city_name: @arr_city_name)
		if @route.dep_country_code == @country_code &&  @route.arr_country_code == @country_code
			@section = @country_code + "-dom"
		else
			@section = @country_code + "-int"
		end
		 
		@route_details =  {:dep_city_code => @route.dep_city_code,
											  :arr_city_code => @route.arr_city_code,
											  :dep_airport_code => @route.dep_airport_code,
											  :arr_airport_code => @route.arr_airport_code,
											  :dep_country_code => @route.dep_country_code,
												:arr_country_code => @route.arr_country_code,
												:dep_city_name => @dep_city_name,
												:arr_city_name => @arr_city_name,
												:country_code => @country_code,
												:section => @section}
		
		@domestic_carrier_codes = AirlineBrand.where(country_code: @country_code).pluck("distinct(carrier_code)")
		@all_carrier_codes = AirlineBrand.all.pluck(:carrier_code)
		unless (@section.include? "int")
      inc_cc = "carrier_code in ('#{@domestic_carrier_codes.join("\',\'")}')"
    else
      inc_cc =  "carrier_code in ('#{@all_carrier_codes.join("\',\'")}')"
    end
		@schedule_routes = @route.flight_schedule_collectives.where("#{inc_cc}").order("dep_time asc").limit(15)
		flight_schedule_service = FlightScheduleService.new @route_details
		operational_airline_codes = @schedule_routes.group_by{|al| al.carrier_code}.map{|k,v| [k,v.count]}.to_h
		operational_airline_names = operational_airline_codes.map{|k,v| I18n.t("airlines.#{k}")}
		schedule_layout_values = {}
		schedule_layout_values["schedule_routes"] = @schedule_routes
		schedule_layout_values["dep_city_name"] = @route.dep_city_name
		schedule_layout_values["arr_city_name"] = @route.arr_city_name
		schedule_layout_values["dep_city_code"] = @route.dep_city_code
		schedule_layout_values["arr_city_code"] = @route.arr_city_code
		schedule_layout_values["dep_airport_code"] = @route.dep_airport_code
		schedule_layout_values["arr_airport_code"] = @route.arr_airport_code
		schedule_layout_values["dep_airport_name"] = Airport.find_by(airport_code: @route.dep_airport_code).airport_name
		schedule_layout_values["arr_airport_name"] = Airport.find_by(airport_code: @route.arr_airport_code).airport_name
		schedule_layout_values["country_code"] = @country_code
		schedule_layout_values["country_name"] = country_name
		schedule_layout_values["dep_country_code"] = @route.dep_country_code
		schedule_layout_values["arr_country_code"] = @route.arr_country_code
		schedule_layout_values["first_dep_airline"]  =  I18n.t("airlines.#{@schedule_routes.first[:carrier_code]}")
		schedule_layout_values["first_dep_airline_no"] = @schedule_routes.first[:flight_no]
		schedule_layout_values["first_dep_time"] = Time.strptime(@schedule_routes.first[:dep_time],"%H:%M").to_time.strftime("%I:%M %p")
		schedule_layout_values["last_dep_airline"] = I18n.t("airlines.#{@schedule_routes.last[:carrier_code]}")
		schedule_layout_values["last_dep_time"]  = Time.strptime(@schedule_routes.last[:dep_time],"%H:%M").to_time.strftime("%I:%M %p")
		schedule_layout_values["last_dep_airline_no"] = @schedule_routes.last[:flight_no]
		schedule_layout_values["min_duration"] = @schedule_routes.collect{|r| r[:duration]}.min.include? (":")   
		schedule_layout_values["max_duration"] = @schedule_routes.collect{|r| r[:duration]}.max.include? (":")
		schedule_layout_values["return_url"]  = flight_schedule_service.schedule_layout_values["return_url"]
		schedule_layout_values["top_dom_airlines"] = flight_schedule_service.schedule_layout_values["top_dom_airlines"]
		schedule_layout_values["top_int_airlines"] = flight_schedule_service.schedule_layout_values["top_int_airlines"]
		schedule_layout_values["distance"] = @route.distance
		schedule_layout_values["weekly_flights_count"] = @route.weekly_flights_count
		schedule_layout_values["operational_airlines"] = operational_airline_names

		if @section.include? ("dom") 
			partial = "flight_schedule_routes/#{@language}/flight_schedule_dom_#{@language.downcase}_#{@country_code.downcase}"
		else
			partial = "flight_schedule_routes/#{@language}/flight_schedule_int_#{@language.downcase}_#{@country_code.downcase}"
		end
		render  partial,locals: {schedule_layout_values: schedule_layout_values,dep_city_name: @dep_city_name,arr_city_name: @arr_city_name,dep_city_code: @dep_city_code,arr_city_code: @arr_city_code }
	end


	def host_name(host)
    # puts "country_code - #{country_code}"
    if host == 'localhost'
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

  