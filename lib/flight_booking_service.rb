require_relative './support/constants.rb'
require 'net/http'

class FlightBookingService
	def initialize(args={})
		@carrier_code = args[:carrier_code]
		@carrier_name = args[:carrier_name]
		@country_code = args[:country_code]
		@section = args[:section]
	end

  def airline_popular_routes

  	airline_dom_dom_routes =  UniqueRoute.joins(:flight_schedule_collectives).where(["flight_schedule_collectives.carrier_code=? and flight_schedule_collectives.dep_city_code!=flight_schedule_collectives.arr_city_code and flight_schedule_collectives.dep_country_code= ? and flight_schedule_collectives.arr_country_code=?",@carrier_code,@country_code,@country_code]).group("flight_schedule_collectives.dep_city_code,flight_schedule_collectives.arr_city_code,unique_routes.weekly_flights_count,flight_schedule_collectives.flight_no").order("unique_routes.weekly_flights_count desc").limit(5)

  	airline_dom_int_routes =  UniqueRoute.joins(:flight_schedule_collectives).where(["flight_schedule_collectives.carrier_code=? and flight_schedule_collectives.dep_city_code!=flight_schedule_collectives.arr_city_code and (flight_schedule_collectives.dep_country_code=? and flight_schedule_collectives.arr_country_code!=?)OR(flight_schedule_collectives.dep_country_code!=? and flight_schedule_collectives.arr_country_code=?) ",@carrier_code,@country_code,@country_code,@country_code,@country_code]).group("flight_schedule_collectives.dep_city_code,flight_schedule_collectives.arr_city_code,unique_routes.weekly_flights_count").order("unique_routes.weekly_flights_count desc").limit(30)

	  airline_int_int_routes =  UniqueRoute.joins(:flight_schedule_collectives).where(["flight_schedule_collectives.carrier_code=? and flight_schedule_collectives.dep_city_code!=flight_schedule_collectives.arr_city_code and (flight_schedule_collectives.dep_country_code!=? and flight_schedule_collectives.arr_country_code!=?)",@carrier_code,@country_code,@country_code]).group("flight_schedule_collectives.dep_city_code,flight_schedule_collectives.arr_city_code,unique_routes.weekly_flights_count").order("unique_routes.weekly_flights_count desc").limit(30)
		  
		  popular_routes = {"dom_dom" => [],
		  									"dom_int" => [],
		  								  "int_int" => []}
		  # flight_schedule_service = FlightScheduleService.new {}
		  unless airline_dom_dom_routes.nil? || airline_dom_dom_routes.count==0

			  airline_dom_dom_routes.each do |route|

			  	@record = FlightScheduleCollective.find_by(unique_route_id: route.id,carrier_code: @carrier_code)
			  	# min_price,max_price = flight_schedule_service.get_price_new(route.dep_city_code,route.arr_city_code,@carrier_code,@carrier_name)
			  	popular_routes["dom_dom"] << {
		  			"carrier_code" => @carrier_code,
		  			"carrier_name" => @carrier_name,
		  			"dep_city_name" => route.dep_city_name,
		  			"arr_city_name" => route.arr_city_name,
		  			"dep_city_code" => route.dep_city_code,
		  			"arr_city_code" => route.arr_city_code,
		  			"dep_airport_code" => route.dep_airport_code,
		  			"arr_airport_code" => route.arr_airport_code,
		  			"dep_time" => @record.dep_time ,
		  			"arr_time" => @record.arr_time ,
		  			"op_days" => @record.days_of_operation,
		  			"flight_no"=> @record.flight_no
		  			# "min_price" => min_price,
		  			# "max_price" => max_price
			  	}
			  end
			end
			# unless airline_dom_int_routes.nil? || airline_dom_int_routes.count==0
			#   airline_dom_int_routes.each do |route|
			#   	record = FlightScheduleCollective.find_by(unique_route_id: route.id,carrier_code: @carrier_code)

			#   	# min_price,max_price = flight_schedule_service.get_price_new(route.dep_city_code,route.arr_city_code,@carrier_code,@carrier_name)
			#   	popular_routes["dom_dom"] << {
		 #  			"carrier_code" => @carrier_code,
		 #  			"carrier_name" => @carrier_name,
		 #  			"dep_city_name" => route.dep_city_name,
		 #  			"arr_city_name" => route.arr_city_name,
		 #  			"dep_city_code" => route.dep_city_code,
		 #  			"arr_city_code" => route.arr_city_code,
		 #  			"dep_airport_code" => route.dep_airport_code,
		 #  			"arr_airport_code" => route.arr_airport_code,
		 #  			"dep_time" => record.dep_time,
		 #  			"arr_time" => record.arr_time,
		 #  			"op_days" => record.days_of_operation,
		 #  			"flight_no"=> record.flight_no
		 #  			# "min_price" => min_price,
		 #  			# "max_price" => max_price
			#   	}
			#   end
			# end
			# unless airline_int_int_routes.nil? || airline_int_int_routes.count==0
			#   airline_dom_int_routes.each do |route|
			#   	record = FlightScheduleCollective.find_by(unique_route_id: route.id,carrier_code: @carrier_code)

			#   	# min_price,max_price = flight_schedule_service.get_price_new(route.dep_city_code,route.arr_city_code,@carrier_code,@carrier_name)
			#   	popular_routes["dom_dom"] << {
		 #  			"carrier_code" => @carrier_code,
		 #  			"carrier_name" => @carrier_name,
		 #  			"dep_city_name" => route.dep_city_name,
		 #  			"arr_city_name" => route.arr_city_name,
		 #  			"dep_city_code" => route.dep_city_code,
		 #  			"arr_city_code" => route.arr_city_code,
		 #  			"dep_airport_code" => route.dep_airport_code,
		 #  			"arr_airport_code" => route.arr_airport_code,
		 #  			"dep_time" => record.dep_time,
		 #  			"arr_time" => record.arr_time,
		 #  			"op_days" => record.days_of_operation,
		 #  			"flight_no"=> record.flight_no
		 #  			# "min_price" => min_price,
		 #  			# "max_price" => max_price
			#   	}
			#   end
			# end

	  binding.pry
	  return popular_routes
  end

end