class FlightTicketsController < ApplicationController
	include ApplicationHelper
	def ticket_values
		domain = request.domain
		path = "#{request.fullpath}"
		@file_name = params[:route] + ".html"
		url = params[:route].gsub("-cheap-airtickets",'')
		@application_processor = ApplicationProcessor.new
		@country_code = @application_processor.host_country_code(domain)[0]
		@country_name = @application_processor.host_country_code(domain)[1]
		@language = params[:lang].nil? ? 'en' : params[:lang]
		@host_name = @application_processor.host_name(@country_code)
		check_domain = check_domain(@language,@country_code)
		if check_domain
			lang = @language == "en" ? "" : "#{@language}"
			if @country_code == "IN"
					redirect_to "#{@host_name}/flight-tickets/cheap-flight-air-tickets-domestic.html" and return
			else
				redirect_to "#{@host_name}/#{lang}/flight-tickets/cheap-flight-air-tickets-domestic.html" and return
			end
		end
		if params[:route].include?("cheap-flight-air-tickets")
			get_ticket_index_values 
			return
		end
		@page_type="flight-tickets"
		@meta_page_type = "flight-tickets"
		@route = UniqueRoute.find_by(schedule_route_url: url)
		if @route.nil? || !@route.present?
			@route = UniqueHopRoute.find_by(url: url)
			if @route.nil? || !@route.present?
				redirect_to "#{@host_name}/flight-tickets/cheap-flight-air-tickets-domestic.html" and return
			end
			hop_ticket_values = get_hop_ticket_values
			return
		end
		dep_city = CityName.find_by(city_code: @route.dep_city_code)
		arr_city = CityName.find_by(city_code: @route.arr_city_code)
		@dep_city_name  = dep_city.city_name_en.titleize
		@arr_city_name = arr_city.city_name_en.titleize
		@dep_city_name_ar  = dep_city.city_name_ar rescue ""
		@arr_city_name_ar = arr_city.city_name_ar rescue ""
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
		flight_ticket_service = FlightTicketService.new @route_details	 
		ticket_footer = flight_ticket_service.ticket_footer
		@domestic_carrier_codes = AirlineBrand.where(country_code: @country_code).pluck("distinct(carrier_code)")
		@all_carrier_codes = AirlineBrand.all.pluck(:carrier_code)

		unless (@section.include? "int")
      inc_cc = "carrier_code in ('#{@domestic_carrier_codes.join("\',\'")}')"
    else
      inc_cc =  "carrier_code in ('#{@all_carrier_codes.join("\',\'")}')"
    end
    case @country_code
    when  "IN"
    	@ticket_routes = @route.in_flight_ticket_collectives.where("#{inc_cc}").order("dep_time asc").limit(10)
    when  "AE"
    	@ticket_routes = @route.in_flight_ticket_collectives.where("#{inc_cc}").order("dep_time asc").limit(10)
    when  "SA"
    	@ticket_routes = @route.in_flight_ticket_collectives.where("#{inc_cc}").order("dep_time asc").limit(10)
    when  "BH"
    	@ticket_routes = @route.in_flight_ticket_collectives.where("#{inc_cc}").order("dep_time asc").limit(10)
    when  "QA"
    	@ticket_routes = @route.in_flight_ticket_collectives.where("#{inc_cc}").order("dep_time asc").limit(10)
    when  "KW"
    	@ticket_routes = @route.in_flight_ticket_collectives.where("#{inc_cc}").order("dep_time asc").limit(10)
    when  "OM"
    	@ticket_routes = @route.in_flight_ticket_collectives.where("#{inc_cc}").order("dep_time asc").limit(10)
    else
    	@ticket_routes = @route.in_flight_ticket_collectives.where("#{inc_cc}").order("dep_time asc").limit(10)	
    end
    if @ticket_routes.empty?
    	redirect_to "#{@host_name}/flight-schedule/flight-schedules-domestic.html" and return
    end
		header_values = flight_ticket_service.ticket_header_details
		ticket_layout_values = flight_ticket_service.ticket_values(@ticket_routes)
		@dep_city_name_formated = ticket_layout_values["dep_city_name_formated"]
		@arr_city_name_formated = ticket_layout_values["arr_city_name_formated"]
		@title_min_price = ticket_layout_values["route_min_price"]
		partial = "tickets/routes/#{@language}/direct/flight_tickets_#{@country_code.downcase}_#{@language.downcase}_#{@section[3..5]}"
		render  partial,locals: {ticket_layout_values: ticket_layout_values,dep_city_name: @dep_city_name,arr_city_name: @arr_city_name,dep_city_name_ar: @dep_city_name_ar,arr_city_name_ar: @arr_city_name_ar,dep_city_code: @route.dep_city_code,arr_city_code: @route.arr_city_code,ticket_header: header_values,ticket_footer: ticket_footer }
	end
	def get_hop_ticket_values
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
		flight_ticket_service = FlightTicketService.new @route_details	 
		@domestic_carrier_codes = AirlineBrand.where(country_code: @country_code).pluck("distinct(carrier_code)")
		@all_carrier_codes = AirlineBrand.all.pluck(:carrier_code)

		unless (@section.include? "int")
      inc_cc = "carrier_code in ('#{@domestic_carrier_codes.join("\',\'")}')"
    else
      inc_cc =  "carrier_code in ('#{@all_carrier_codes.join("\',\'")}')"
    end
    # comented because only in_flight_hop_schedule_collectives table has data
    # uncomment after feeding data to respective tables
    case @country_code
    when  "IN"
    	@ticket_routes = @route.in_flight_hop_schedule_collectives.where("#{inc_cc}").order("dep_time asc").limit(10)
    when  "AE"
    	@ticket_routes = @route.ae_flight_schedule_collectives.where("#{inc_cc}").order("dep_time asc").limit(10)
    when  "SA"
    	@ticket_routes = @route.sa_flight_hop_schedule_collectives.where("#{inc_cc}").order("dep_time asc").limit(10)
    when  "BH"
    	@ticket_routes = @route.bh_flight_hop_schedule_collectives.where("#{inc_cc}").order("dep_time asc").limit(10)
    when  "QA"
    	@ticket_routes = @route.qa_flight_hop_schedule_collectives.where("#{inc_cc}").order("dep_time asc").limit(10)
    when  "KW"
    	@ticket_routes = @route.kw_flight_hop_schedule_collectives.where("#{inc_cc}").order("dep_time asc").limit(10)
    when  "OM"
    	@ticket_routes = @route.om_flight_hop_schedule_collectives.where("#{inc_cc}").order("dep_time asc").limit(10)
    else
    	@ticket_routes = @route.in_flight_hop_schedule_collectives.where("#{inc_cc}").order("dep_time asc").limit(10)
    end
    # @ticket_routes = @route.ae_flight_hop_ticket_collectives.where("#{inc_cc}").order("dep_time asc").limit(10)
    if @ticket_routes.empty?
    	redirect_to "#{@host_name}/flight-schedule/flight-schedules-domestic.html" and return
    end
    header_values = flight_ticket_service.ticket_header_details
		ticket_layout_values = flight_ticket_service.ticket_hop_values(@ticket_routes)
		@title_min_price = ticket_layout_values["route_min_price"]
		ticket_footer = flight_ticket_service.ticket_footer
		@dep_city_name_formated = ticket_layout_values["dep_city_name_formated"]
		@arr_city_name_formated = ticket_layout_values["arr_city_name_formated"]
		partial = "tickets/routes/#{@language}/hop/flight_ticket_hop_#{@country_code.downcase}_#{@language.downcase}_#{@section[3..5]}"
		render  partial,locals: {ticket_layout_values: ticket_layout_values,dep_city_name: @dep_city_name,arr_city_name: @arr_city_name,dep_city_name_ar: @dep_city_name_ar,arr_city_name_ar: @arr_city_name_ar,dep_city_code: @route.dep_city_code,arr_city_code: @route.arr_city_code,ticket_header: header_values,ticket_footer: ticket_footer }
	end

	def get_ticket_index_values
		lang= @language == "ar" ? "/ar" : ""
		page_no = @file_name.gsub(/[^0-9]/,'').to_i || 0
		@page_type="flight-tickets"
		@meta_page_type = "ticket_index"
		@section = params[:route].include?("domestic") ? "dom" : "int"
		args = {language: @language,
						country_code: @country_code,
						section: @section}
		flight_ticket_service = FlightTicketService.new args
		index_values = flight_ticket_service.index_values
		more_routes = flight_ticket_service.index_more_routes
		rhs_top_airlines = flight_ticket_service.index_rhs_top_airlines
		rhs_top_airports = flight_ticket_service.index_rhs_top_airports
		pagination = custom_pagination(page_no,more_routes,@file_name)
		partial =  "tickets/index/#{@language.downcase}/flight_ticket_#{@language.downcase}_#{@section}_index"
		render partial, locals: {index_values: index_values,pagination: pagination,popular_routes: index_values,rhs_top_airlines: rhs_top_airlines,rhs_top_airports: rhs_top_airports,rhs_top_routes: more_routes[0..5]}
	end
end
