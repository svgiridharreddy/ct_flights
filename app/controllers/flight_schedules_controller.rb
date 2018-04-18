class FlightSchedulesController < ApplicationController
	include ApplicationHelper
	def index
		redirect_to "https://www.cleartrip.com/flights" and return
	end
	def schedule_values
		domain = request.domain
		path = "#{request.fullpath}"

		@file_name = params[:route] + ".html"
		url = params[:route].gsub("-flights","")
		@application_processor = ApplicationProcessor.new
		@country_code = @application_processor.host_country_code(domain)[0]
		@country_name = @application_processor.host_country_code(domain)[1]
		@language = params[:lang].nil? ? 'en' : params[:lang]
		@page_type="flight-schedule"
		@host_name = @application_processor.host_name(@country_code)
		check_domain = check_domain(@language,@country_code)
		if check_domain
			lang = @language == "en" ? "" : "#{@language}"
			if @country_code == "IN"
					redirect_to "#{@host_name}/flight-schedule/flight-schedules-domestic.html" and return
			else
				redirect_to "#{@host_name}/#{lang}/flight-schedule/flight-schedules-domestic.html" and return
			end
		end
		if path.include?("flights-from") || path.include?("flights-to")
			get_from_to(path)
			return
		end

		@route = UniqueRoute.find_by(schedule_route_url: url)
		
		if @route.nil? || !@route.present?
			@route = UniqueHopRoute.find_by(url: url)
			if @route.nil? || !@route.present?
				redirect_to "#{@host_name}/flight-schedule/flight-schedules-domestic.html" and return
			end
			hop_schedule_values = get_hop_schedule_values
			return
		end
		dep_city = CityName.find_by(city_code: @route.dep_city_code)
		arr_city = CityName.find_by(city_code: @route.arr_city_code)
		@dep_city_name  = dep_city.city_name_en.titleize
		@arr_city_name = arr_city.city_name_en.titleize
		@dep_city_name_ar  = dep_city.city_name_ar rescue ""
		@arr_city_name_ar = arr_city.city_name_ar rescue ""
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
    case @country_code
    when  "IN"
    	@schedule_routes = @route.in_flight_schedule_collectives.where("#{inc_cc}").order("dep_time asc").limit(10)
    when  "AE"
    	@schedule_routes = @route.ae_flight_schedule_collectives.where("#{inc_cc}").order("dep_time asc").limit(10)
    when  "SA"
    	@schedule_routes = @route.sa_flight_schedule_collectives.where("#{inc_cc}").order("dep_time asc").limit(10)
    when  "BH"
    	@schedule_routes = @route.bh_flight_schedule_collectives.where("#{inc_cc}").order("dep_time asc").limit(10)
    when  "QA"
    	@schedule_routes = @route.qa_flight_schedule_collectives.where("#{inc_cc}").order("dep_time asc").limit(10)
    when  "KW"
    	@schedule_routes = @route.kw_flight_schedule_collectives.where("#{inc_cc}").order("dep_time asc").limit(10)
    when  "OM"
    	@schedule_routes = @route.om_flight_schedule_collectives.where("#{inc_cc}").order("dep_time asc").limit(10)
    else
    	@schedule_routes = @route.in_flight_schedule_collectives.where("#{inc_cc}").order("dep_time asc").limit(10)	
    end
    if @schedule_routes.empty?
    	redirect_to "#{@host_name}/flight-schedule/flight-schedules-domestic.html" and return
    end
		header_values = flight_schedule_service.schedule_header_details
		schedule_layout_values = flight_schedule_service.schedule_values(@schedule_routes)
		@dep_city_name_formated = schedule_layout_values["dep_city_name_formated"]
		@arr_city_name_formated = schedule_layout_values["arr_city_name_formated"]
		@title_min_price = schedule_layout_values["route_min_price"]
		partial = "schedules/routes/#{@language}/flight_schedule_#{@section[3..5]}_#{@language.downcase}_#{@country_code.downcase}"
		render  partial,locals: {schedule_layout_values: schedule_layout_values,dep_city_name: @dep_city_name,arr_city_name: @arr_city_name,dep_city_name_ar: @dep_city_name_ar,arr_city_name_ar: @arr_city_name_ar,dep_city_code: @route.dep_city_code,arr_city_code: @route.arr_city_code,schedule_header: header_values,schedule_footer: schedule_footer }
	end

	def get_from_to(path)
		@city_section = path.include?("from") ? "from" : "to"
		@page_type = @city_section
		lang= @language=="ar" ? "/ar" : ""
		url =  path.gsub("#{lang}/flight-schedule/",'').gsub(/-\d/,'').gsub('.html','')
		if  @city_section == "from"
			city = CityName.find_by(from_url: url)
		else
			city = CityName.find_by(to_url: url)
		end
		if !city.present? || city.nil?
			redirect_to "#{@host_name}/flight-schedule/flight-schedules-domestic.html" and return
		end
		@city_name = city.city_name_en
		@city_name_ar = city.city_name_ar
		@city_code = city.city_code
		@city_country_code = UniqueRoute.find_by(dep_city_code: @city_code).dep_country_code
		@section = @city_country_code == @country_code ? "dom" : "int"
		flight_flight_name = url + ".html"
		@values = { country_code: @country_code,
							  country_name: @country_name,
							  language: @language,
							  city_code: @city_code
							}
		page_no = path.gsub("#{lang}/flight-schedule/flights-#{@city_section}-",'').gsub(/[^0-9]/,'').to_i || 0
		host = @application_processor.host_name(@country_code)
		flight_schedule_service = FlightScheduleService.new @values
		from_to_values = flight_schedule_service.from_to_values(@city_code,@city_section,page_no)
		city_layout_values = flight_schedule_service.city_layout_values(@city_code, @city_section,@city_name,page_no)
		schedule_footer = flight_schedule_service.schedule_footer
		pagination = custom_pagination(page_no,city_layout_values["#{@city_section}_more_routes"],flight_flight_name)
		if @city_section === "from"
			partial = "schedules/from_to/#{@language}/from_city_#{@country_code.downcase}_#{@language.downcase}"
		else
			partial = "schedules/from_to/#{@language}/to_city_#{@country_code.downcase}_#{@language.downcase}"
		end
		render partial, locals: {popular_routes: from_to_values,application_processor: @application_processor,page_type: "flight-schedule",first_file_name: flight_flight_name,city_layout_values: city_layout_values,host: host,schedule_footer: schedule_footer,pagination: pagination}
	end

	def get_hop_schedule_values
		
		dep_city = CityName.find_by(city_code: @route.dep_city_code)
		arr_city = CityName.find_by(city_code: @route.arr_city_code)
		@dep_city_name  = dep_city.city_name_en.titleize
		@arr_city_name = arr_city.city_name_en.titleize
		@dep_city_name_ar  = dep_city.city_name_ar rescue ""
		@arr_city_name_ar = arr_city.city_name_ar rescue ""
		@route_details = {  :dep_city_code => @route.dep_city_code,
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
		if @route.dep_country_code == @country_code &&  @route.arr_country_code == @country_code
			@section = @country_code + "-dom"
		else
			@section = @country_code + "-int"
		end
		binding.pry

		flight_schedule_service = FlightScheduleService.new @route_details	 
		schedule_footer = flight_schedule_service.schedule_footer
		@domestic_carrier_codes = AirlineBrand.where(country_code: @country_code).pluck("distinct(carrier_code)")
		@all_carrier_codes = AirlineBrand.all.pluck(:carrier_code)

		unless (@section.include? "int")
      inc_cc = "carrier_code in ('#{@domestic_carrier_codes.join("\',\'")}')"
    else
      inc_cc =  "carrier_code in ('#{@all_carrier_codes.join("\',\'")}')"
    end
    # comented because only in_flight_hop_schedule_collectives table has data
    # uncomment after feeding data to respective tables
    # case @country_code
    # when  "IN"
    # 	@schedule_routes = @route.in_flight_hop_schedule_collectives.where("#{inc_cc}").order("dep_time asc").limit(10)
    # when  "AE"
    # 	@schedule_routes = @route.ae_flight_schedule_collectives.where("#{inc_cc}").order("dep_time asc").limit(10)
    # when  "SA"
    # 	@schedule_routes = @route.sa_flight_hop_schedule_collectives.where("#{inc_cc}").order("dep_time asc").limit(10)
    # when  "BH"
    # 	@schedule_routes = @route.bh_flight_hop_schedule_collectives.where("#{inc_cc}").order("dep_time asc").limit(10)
    # when  "QA"
    # 	@schedule_routes = @route.qa_flight_hop_schedule_collectives.where("#{inc_cc}").order("dep_time asc").limit(10)
    # when  "KW"
    # 	@schedule_routes = @route.kw_flight_hop_schedule_collectives.where("#{inc_cc}").order("dep_time asc").limit(10)
    # when  "OM"
    # 	@schedule_routes = @route.om_flight_hop_schedule_collectives.where("#{inc_cc}").order("dep_time asc").limit(10)
    # else
    # 	@schedule_routes = @route.in_flight_hop_schedule_collectives.where("#{inc_cc}").order("dep_time asc").limit(10)
    # end
    @schedule_routes = @route.in_flight_hop_schedule_collectives.where("#{inc_cc}").order("dep_time asc").limit(10)
		header_values = flight_schedule_service.schedule_header_details
		schedule_layout_values = flight_schedule_service.schedule_hop_values(@schedule_routes)
		@title_min_price = 0 #schedule_layout_values["route_min_price"]
		@dep_city_name_formated = schedule_layout_values["dep_city_name_formated"]
		@arr_city_name_formated = schedule_layout_values["arr_city_name_formated"]
		partial = "schedules/routes/#{@language}/hops/flight_schedule_hop_#{@country_code.downcase}_#{@language.downcase}_#{@section[3..5]}"
		render  partial,locals: {schedule_layout_values: schedule_layout_values,dep_city_name: @dep_city_name,arr_city_name: @arr_city_name,dep_city_name_ar: @dep_city_name_ar,arr_city_name_ar: @arr_city_name_ar,dep_city_code: @route.dep_city_code,arr_city_code: @route.arr_city_code,schedule_header: header_values,schedule_footer: schedule_footer }
	end
end

