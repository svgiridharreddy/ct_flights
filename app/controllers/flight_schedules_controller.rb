class FlightSchedulesController < ApplicationController

	def schedule_values
		@dep_city_name  = params[:dep_city_name].titleize
		@arr_city_name = params[:arr_city_name].titleize
		  
		@route = UniqueRoute.find_by(dep_city_name: @dep_city_name,arr_city_name: @arr_city_name)
		@dep_city_code = @route.dep_city_code
		@arr_city_code = @route.arr_city_code
		@dep_airport_code = @route.dep_airport_code
		@arr_airport_code = @route.arr_airport_code
		@dep_country_code = @route.dep_country_code
		@arr_country_code = @route.arr_country_code
		@schedule_layout_values = {}
		@domestic_carrier_codes = AirlineBrand.where(country_code: 'IN').pluck("distinct(carrier_code)")
		@schedule_routes = @route.flight_schedule_collectives.where(carrier_code: @domestic_carrier_codes).order("dep_time asc").limit(20)
		flight_schedule_service = FlightScheduleService.new({dep_city_code: @dep_city_code,arr_city_code: @arr_city_code,dep_city_name: @dep_city_name,arr_city_name: @arr_city_name,dep_airport_code:@dep_airport_code,arr_airport_code: @arr_airport_code,dep_country_code: @dep_country_code,arr_country_code: @dep_country_code})
		operational_airline_codes = @schedule_routes.group_by{|al| al.carrier_code}.map{|k,v| [k,v.count]}.to_h
		operational_airline_names = operational_airline_codes.map{|k,v| I18n.t("airlines.#{k}")}
		
		@schedule_layout_values["schedule_routes"] = @schedule_routes
		@schedule_layout_values["dep_city_name"] = @dep_city_name
		@schedule_layout_values["arr_city_name"] = @arr_city_name
		@schedule_layout_values["dep_airport_code"] = @dep_airport_code
		@schedule_layout_values["arr_airport_code"] = @arr_airport_code
		@schedule_layout_values["dep_country_code"] = @dep_country_code
		@schedule_layout_values["arr_country_code"] = @arr_country_code
		@schedule_layout_values["first_dep_airline"]  =  I18n.t("airlines.#{@schedule_routes.first[:carrier_code]}")
		@schedule_layout_values["first_dep_airline_no"] = @schedule_routes.first[:flight_no]
		@schedule_layout_values["first_dep_time"] = @schedule_routes.first[:dep_time]
		@schedule_layout_values["last_dep_airline"] = I18n.t("airlines.#{@schedule_routes.last[:carrier_code]}")
		@schedule_layout_values["last_dep_time"]  = @schedule_routes.last[:dep_time]
		@schedule_layout_values["min_duration"] = @schedule_routes.collect{|r| r[:duration]}.min.include? (":")   
		@schedule_layout_values["max_duration"] = @schedule_routes.collect{|r| r[:duration]}.max.include? (":")
		@schedule_layout_values["rhs_airlines"] = flight_schedule_service.schedule_layout_values
		@schedule_layout_values["distance"] = @route.distance
		render  "flight_schedules/schedule_routes",locals: {schedule_layout_values: @schedule_layout_values,dep_city_name: @dep_city_name,arr_city_name: @arr_city_name }
	end

	
	
end

  