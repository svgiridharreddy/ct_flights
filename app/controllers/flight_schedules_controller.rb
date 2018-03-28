class FlightSchedulesController < ApplicationController

	def schedule_values
		domain = request.domain
		path = "#{request.fullpath}"
		
		url = params[:route].gsub("-flights","")
		@application_processor = ApplicationProcessor.new
		@country_code = @application_processor.host_country_code(domain)[0]
		@country_name = @application_processor.host_country_code(domain)[1]
		@language = params[:lang].nil? ? 'en' : params[:lang]
		if path.include?("flights-from") || path.include?("flights-to")
			get_from_to(path)
			return
		end
		@route = UniqueRoute.find_by(schedule_route_url: url)
		@dep_city_name  = CityName.find_by(city_code: @route.dep_city_code).city_name_en.titleize
		@arr_city_name = CityName.find_by(city_code: @route.arr_city_code).city_name_en.titleize
		# @route_type = @route.hop == 0 ? "non-stop" : "hop"
		# binding.pry
		@route_type = "non-stop"
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
		schedule_footer = flight_schedule_service.schedule_footer
		@domestic_carrier_codes = AirlineBrand.where(country_code: @country_code).pluck("distinct(carrier_code)")
		@all_carrier_codes = AirlineBrand.all.pluck(:carrier_code)

		unless (@section.include? "int")
      inc_cc = "carrier_code in ('#{@domestic_carrier_codes.join("\',\'")}')"
    else
      inc_cc =  "carrier_code in ('#{@all_carrier_codes.join("\',\'")}')"
    end
		@schedule_routes = @route.flight_schedule_collectives.where("#{inc_cc}").order("dep_time asc").limit(10)
		header_values = flight_schedule_service.schedule_header_details
		schedule_layout_values = flight_schedule_service.schedule_values(@schedule_routes)
		if @section.include? ("dom") 
			partial = "flight_schedule_routes/#{@language}/flight_schedule_dom_#{@language.downcase}_#{@country_code.downcase}"
		else
			partial = "flight_schedule_routes/#{@language}/flight_schedule_int_#{@language.downcase}_#{@country_code.downcase}"
		end
		render  partial,locals: {schedule_layout_values: schedule_layout_values,dep_city_name: @dep_city_name,arr_city_name: @arr_city_name,dep_city_code: @route.dep_city_code,arr_city_code: @route.arr_city_code,schedule_header: header_values,schedule_footer: schedule_footer }
	end

	def get_from_to(path)
		@city_section = path.include?("from") ? "from" : "to"
		@city_name = path.gsub("/flight-schedule/flights-#{@city_section}-",'').gsub('.html','').gsub('-','').titleize
		city = UniqueRoute.find_by(dep_city_name: @city_name)
		@city_code = city.dep_city_code
		@city_country_code = city.dep_country_code
		file_name = path.split("/")[2]
		@values = {country_code: @country_code,
							 country_name: @country_name,
							 language: @language
							}
		host = @application_processor.host_name(@country_code)
		flight_schedule_service = FlightScheduleService.new @values
		from_to_values = flight_schedule_service.from_to_values(@city_code,@city_section)
		city_layout_values = flight_schedule_service.city_layout_values(@city_code, @city_section)
		if @city_section === "from"
			partial = "schedules/from_to/#{@language}/from_city_#{@country_code.downcase}_#{@language.downcase}"
			
		else
			partial = "schedules/from_to/#{@language}/to_city_#{@country_code.downcase}_#{@language.downcase}"
			
		end
		render partial, locals: {popular_routes: from_to_values,application_processor: @application_processor,page_type: "flight-schedule",first_file_name: file_name,city_layout_values: city_layout_values,host: host}
	end
end

