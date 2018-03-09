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

  	airline_dom_dom_routes =  UniqueRoute.joins(:flight_schedule_collectives).where(["flight_schedule_collectives.carrier_code=? and flight_schedule_collectives.dep_city_code!=flight_schedule_collectives.arr_city_code and flight_schedule_collectives.dep_country_code= ? and flight_schedule_collectives.arr_country_code=?",@carrier_code,@country_code,@country_code]).group("flight_schedule_collectives.dep_city_code,flight_schedule_collectives.arr_city_code,unique_routes.weekly_flights_count,flight_schedule_collectives.flight_no").order("unique_routes.weekly_flights_count desc").limit(30)

  	airline_dom_int_routes =  UniqueRoute.joins(:flight_schedule_collectives).where(["flight_schedule_collectives.carrier_code=? and flight_schedule_collectives.dep_city_code!=flight_schedule_collectives.arr_city_code and (flight_schedule_collectives.dep_country_code=? and flight_schedule_collectives.arr_country_code!=?)OR(flight_schedule_collectives.dep_country_code!=? and flight_schedule_collectives.arr_country_code=?)",@carrier_code,@country_code,@country_code,@country_code,@country_code]).group("flight_schedule_collectives.dep_city_code,flight_schedule_collectives.arr_city_code,unique_routes.weekly_flights_count").order("unique_routes.weekly_flights_count desc").limit(30)

	  airline_int_int_routes =  UniqueRoute.joins(:flight_schedule_collectives).where(["flight_schedule_collectives.carrier_code=? and flight_schedule_collectives.dep_city_code!=flight_schedule_collectives.arr_city_code and (flight_schedule_collectives.dep_country_code!=? and flight_schedule_collectives.arr_country_code!=?)",@carrier_code,@country_code,@country_code]).group("flight_schedule_collectives.dep_city_code,flight_schedule_collectives.arr_city_code,unique_routes.weekly_flights_count").order("unique_routes.weekly_flights_count desc").limit(30)
		  popular_routes = {"dom_dom" => [],
		  									"dom_int" => [],
		  								  "int_int" => []}
		  flight_schedule_service = FlightScheduleService.new {}
		  unless airline_dom_dom_routes.nil? || airline_dom_dom_routes.count==0

			  airline_dom_dom_routes.each do |route|

			  	record = FlightScheduleCollective.find_by(unique_route_id: route.id,carrier_code: @carrier_code)
			  	
			  	min_price,max_price = flight_schedule_service.get_price_new(route.dep_city_code,route.arr_city_code,@carrier_code,@carrier_name)
			  	popular_routes["dom_dom"] << {
		  			"carrier_code" => @carrier_code,
		  			"carrier_name" => @carrier_name,
		  			"dep_city_name" => route.dep_city_name,
		  			"arr_city_name" => route.arr_city_name,
		  			"dep_city_code" => route.dep_city_code,
		  			"arr_city_code" => route.arr_city_code,
		  			"dep_airport_code" => route.dep_airport_code,
		  			"arr_airport_code" => route.arr_airport_code,
		  			"dep_time" => record.dep_time ,
		  			"arr_time" => record.arr_time ,
		  			"op_days" => record.days_of_operation,
		  			"flight_no"=> record.flight_no,
		  			"min_price" => min_price,
		  			"max_price" => max_price
			  	}
			  end
			end
			unless airline_dom_int_routes.nil? || airline_dom_int_routes.count==0
			  airline_dom_int_routes.each do |route|
			  	record = FlightScheduleCollective.find_by(unique_route_id: route.id,carrier_code: @carrier_code)
			  	if record.present? && record!=nil
				  	min_price,max_price = flight_schedule_service.get_price_new(route.dep_city_code,route.arr_city_code,@carrier_code,@carrier_name)
				  	popular_routes["dom_int"] << {
			  			"carrier_code" => @carrier_code,
			  			"carrier_name" => @carrier_name,
			  			"dep_city_name" => route.dep_city_name,
			  			"arr_city_name" => route.arr_city_name,
			  			"dep_city_code" => route.dep_city_code,
			  			"arr_city_code" => route.arr_city_code,
			  			"dep_airport_code" => route.dep_airport_code,
			  			"arr_airport_code" => route.arr_airport_code,
			  			"dep_time" => record.dep_time ,
			  			"arr_time" => record.arr_time ,
			  			"op_days" => record.days_of_operation,
			  			"flight_no"=> record.flight_no,	
			  			"min_price" => min_price,
			  			"max_price" => max_price
				  	}
				  end
			  end
			end

			unless airline_int_int_routes.nil? || airline_int_int_routes.count==0
			  airline_int_int_routes.each do |route|
			  	record = FlightScheduleCollective.find_by(unique_route_id: route.id,carrier_code: @carrier_code)
			  	if record.present? && record!=nil
				  	# min_price,max_price = flight_schedule_service.get_price_new(route.dep_city_code,route.arr_city_code,@carrier_code,@carrier_name)
				  	popular_routes["int_int"] << {
			  			"carrier_code" => @carrier_code,
			  			"carrier_name" => @carrier_name,
			  			"dep_city_name" => route.dep_city_name,
			  			"arr_city_name" => route.arr_city_name,
			  			"dep_city_code" => route.dep_city_code,
			  			"arr_city_code" => route.arr_city_code,
			  			"dep_airport_code" => route.dep_airport_code,
			  			"arr_airport_code" => route.arr_airport_code,
			  			"dep_time" => record.dep_time,
			  			"arr_time" => record.arr_time,
			  			"op_days" => record.days_of_operation,
			  			"flight_no"=> record.flight_no
			  			# "min_price" => min_price,
			  			# "max_price" => max_price
				  	}
				  end
				end
			end
			if popular_routes['dom_int'].count == 0 || popular_routes['dom_int'].nil?
      	popular_routes['dom_int'] = popular_routes['int_int'] 
    	elsif popular_routes['dom_int'].count > 0 
      	popular_routes['dom_int'] = popular_routes['dom_int'] + popular_routes['int_int']
    	end
	  return popular_routes
  end
 	def top_dom_int_airports
    airports = {"dom_airports" => [],
                "int_airports" => []
              }
    dom_airport_records = Airport.where("country_code='#{@country_code}' and  airport_routes_count is not NULL").order('airport_routes_count desc').limit(5)
    int_airport_records = Airport.where("country_code!='#{@country_code}' and airport_routes_count is not NULL").order('airport_routes_count desc').limit(5)
    dom_airport_records.each do |airport|
      airports["dom_airports"] << {
        "airport_name" => airport.airport_name,
        "airport_code" => airport.airport_code,
        "city_name" => airport.city_name,
        "city_code" => airport.city_code
      }
    end
    int_airport_records.each do |airport|
      airports["int_airports"] << {
        "airport_name" => airport.airport_name,
        "airport_code" => airport.airport_code,
        "city_name" => airport.city_name,
        "city_code" => airport.city_code
      }
    end
    return airports
  end

  def rhs_top_airlines
  	dom_airlines = AirlineBrand.where(country_code: @country_code).order(brand_routes_count:  :desc).limit(8).pluck(:carrier_code)
  	int_airlines = AirlineBrand.where.not(country_code: @country_code).order(brand_routes_count:  :desc).limit(8).pluck(:carrier_code)
  	return {dom_airlines: dom_airlines,int_airlines: int_airlines}
  end

  def rhs_top_schedule_routes
  	dom_routes = UniqueRoute.where(dep_country_code: @country_code,arr_country_code: @country_code).order(weekly_flights_count:  :desc).limit(5)
  	int_routes = UniqueRoute.where("(dep_country_code= ? and arr_country_code!=?)OR(dep_country_code!= ? and arr_country_code=?) ",@country_code,@country_code,@country_code,@country_code).order(weekly_flights_count:  :desc).limit(5)
  	if int_routes.nil? || !int_routes.present?
  		int_routes = UniqueRoute.where("(dep_country_code!= ? and arr_country_code!=?",@country_code,@country_code).order(weekly_flights_count:  :desc).limit(5)
  	end
  	return {dom_routes: dom_routes,int_routes: int_routes}
  end

end