require 'net/http'

class FlightBookingService
	def initialize(args={})
		@carrier_code = args[:carrier_code]
		@carrier_name = args[:carrier_name]
		@country_code = args[:country_code]
		@section = args[:section]
		@language = args[:language]
	end
	def airline_more_routes
  	collecitves = "#{@country_code.downcase}_flight_schedule_collectives"
  	collectives_symbol = collecitves.to_sym
  		
  	@airline_dom_dom_routes =  UniqueRoute.joins(collectives_symbol).where(["#{collecitves}.carrier_code=? and #{collecitves}.dep_city_code!=#{collecitves}.arr_city_code and #{collecitves}.dep_country_code= ? and #{collecitves}.arr_country_code=?",@carrier_code,@country_code,@country_code]).group("#{collecitves}.dep_city_code,#{collecitves}.arr_city_code,unique_routes.weekly_flights_count,#{collecitves}.flight_no").order("unique_routes.weekly_flights_count desc")

  	@airline_dom_int_routes =  UniqueRoute.joins(collectives_symbol).where(["#{collecitves}.carrier_code=? and #{collecitves}.dep_city_code!=#{collecitves}.arr_city_code and (#{collecitves}.dep_country_code=? and #{collecitves}.arr_country_code!=?)OR(#{collecitves}.dep_country_code!=? and #{collecitves}.arr_country_code=?)",@carrier_code,@country_code,@country_code,@country_code,@country_code]).group("#{collecitves}.dep_city_code,#{collecitves}.arr_city_code,unique_routes.weekly_flights_count").order("unique_routes.weekly_flights_count desc")

	  @airline_int_int_routes =  UniqueRoute.joins(collectives_symbol).where(["#{collecitves}.carrier_code=? and #{collecitves}.dep_city_code!=#{collecitves}.arr_city_code and (#{collecitves}.dep_country_code!=? and #{collecitves}.arr_country_code!=?)",@carrier_code,@country_code,@country_code]).group("#{collecitves}.dep_city_code,#{collecitves}.arr_city_code,unique_routes.weekly_flights_count").order("unique_routes.weekly_flights_count desc")
  	more_routes = @airline_dom_dom_routes + @airline_dom_int_routes + @airline_int_int_routes
  	return more_routes
  end

  def header_airline_routes
  	header_routes = { "dom_dom" => [],
  									  "dom_int" => [],
  									  "int_int" => []}
    unless @airline_dom_dom_routes.nil? || @airline_dom_dom_routes.count==0	
    	@airline_dom_dom_routes[0...10].each do |route|
		  	record = AirlineBrandCollective.find_by(carrier_code: @carrier_code,unique_route_id: route.id)
		  	if record.present? && record !=nil
			  	header_routes["dom_dom"] << {
		  			"carrier_code" => @carrier_code,
		  			"carrier_name" => @carrier_name,
		  			"dep_city_name" => route.dep_city_name,
		  			"arr_city_name" => route.arr_city_name,
		  			"dep_city_name_ar" => route.dep_city_name_ar,
		  			"arr_city_name_ar" => route.arr_city_name_ar,
			  	}
			  end
			end
		end
		unless @airline_dom_int_routes.nil? || @airline_dom_int_routes.count==0	
    	@airline_dom_int_routes[0...10].each do |route|
		  	record = AirlineBrandCollective.find_by(carrier_code: @carrier_code,unique_route_id: route.id)
		  	if record.present? && record !=nil
			  	header_routes["dom_int"] << {
		  			"carrier_code" => @carrier_code,
		  			"carrier_name" => @carrier_name,
		  			"dep_city_name" => route.dep_city_name,
		  			"dep_city_name_ar" => CityName.find_by(city_code: route.dep_city_code).city_name_ar,
		  			"arr_city_name" => route.arr_city_name,
		  			"arr_city_name_ar" => CityName.find_by(city_code: route.arr_city_code).city_name_ar
			  	}
			  end
			end
		end
		unless @airline_dom_int_routes.nil? || @airline_dom_int_routes.count==0	
    	@airline_dom_int_routes[0...10].each do |route|
		  	record = AirlineBrandCollective.find_by(carrier_code: @carrier_code,unique_route_id: route.id)
		  	if record.present? && record !=nil
			  	header_routes["int_int"] << {
		  			"carrier_code" => @carrier_code,
		  			"carrier_name" => @carrier_name,
		  			"dep_city_name" => route.dep_city_name,
		  			"dep_city_name_ar" => CityName.find_by(city_code: route.dep_city_code).city_name_ar,
		  			"arr_city_name" => route.arr_city_name,
		  			"arr_city_name_ar" => CityName.find_by(city_code: route.arr_city_code).city_name_ar
			  	}
			  end
			end
		end
		if header_routes['dom_int'].count == 0 || header_routes['dom_int'].nil?
      header_routes['dom_int'] = header_routes['int_int'] 
    elsif header_routes['dom_int'].count > 0 
      header_routes['dom_int'] = header_routes['dom_int'] + header_routes['int_int']
    end
    return header_routes
  end
 
  def airline_popular_routes
  	
		  @popular_routes = {"dom_dom" => [],
		  									"dom_int" => [],
		  								  "int_int" => []
		  									}
		  flight_schedule_service = FlightScheduleService.new {}
		  unless @airline_dom_dom_routes.nil? || @airline_dom_dom_routes.count==0

			   @airline_dom_dom_routes[0...30].each do |route|
			  	record = AirlineBrandCollective.find_by(carrier_code: @carrier_code,unique_route_id: route.id)
			  	if record.present? && record !=nil
				  	min_price,max_price = flight_schedule_service.get_price(route.dep_city_code,route.arr_city_code,@carrier_code,@carrier_name)
				  	@popular_routes["dom_dom"] << {
			  			"carrier_code" => @carrier_code,
			  			"carrier_name" => @carrier_name,
			  			"dep_city_name" => route.dep_city_name,
			  			"dep_city_name_ar" => route.dep_city_name_ar,
			  			"arr_city_name" => route.arr_city_name,
			  			"arr_city_name_ar" => route.arr_city_name_ar,
			  			"dep_city_code" => route.dep_city_code,
			  			"arr_city_code" => route.arr_city_code,
			  			"dep_airport_code" => route.dep_airport_code,
			  			"arr_airport_code" => route.arr_airport_code,
			  			"dep_time" => record.dep_time,
			  			"arr_time" => record.arr_time,
			  			"op_days" => record.days_of_operation,
			  			"flight_no"=> record.flight_no,
			  			"min_price" => min_price,
			  			"max_price" => max_price
				  	}
				  end
			  end
			end

			unless @airline_dom_int_routes.nil? || @airline_dom_int_routes.count==0
			  @airline_dom_int_routes[0...30].each do |route|
			  	record = AirlineBrandCollective.find_by(carrier_code: @carrier_code,unique_route_id: route.id)
			  	if record.present? && record !=nil
				  	min_price,max_price = flight_schedule_service.get_price(route.dep_city_code,route.arr_city_code,@carrier_code,@carrier_name)
				  	@popular_routes["dom_int"] << {
			  			"carrier_code" => @carrier_code,
			  			"carrier_name" => @carrier_name,
			  			"dep_city_name" => route.dep_city_name,
			  			"dep_city_name_ar" => route.dep_city_name_ar,
			  			"arr_city_name" => route.arr_city_name,
			  			"arr_city_name_ar" => route.arr_city_name_ar,
			  			"dep_city_code" => route.dep_city_code,
			  			"arr_city_code" => route.arr_city_code,
			  			"dep_airport_code" => route.dep_airport_code,
			  			"arr_airport_code" => route.arr_airport_code,
			  			"dep_time" => record.dep_time,
			  			"arr_time" => record.arr_time,
			  			"op_days" => record.days_of_operation,
			  			"flight_no"=> record.flight_no,
			  			"min_price" => min_price,
			  			"max_price" => max_price
				  	}
				  end
			  end
			end

			unless @airline_int_int_routes.nil? || @airline_int_int_routes.count==0
			  @airline_int_int_routes[0...30].each do |route|
			  	record = AirlineBrandCollective.find_by(carrier_code: @carrier_code,unique_route_id: route.id)
			  	if record.present? && record !=nil
				  	min_price,max_price = flight_schedule_service.get_price(route.dep_city_code,route.arr_city_code,@carrier_code,@carrier_name)
				  	@popular_routes["int_int"] << {
			  			"carrier_code" => @carrier_code,
			  			"carrier_name" => @carrier_name,
			  			"dep_city_name" => route.dep_city_name,
			  			"dep_city_name_ar" => route.dep_city_name_ar,
			  			"arr_city_name" => route.arr_city_name,
			  			"arr_city_name_ar" => route.arr_city_name_ar,
			  			"dep_city_code" => route.dep_city_code,
			  			"arr_city_code" => route.arr_city_code,
			  			"dep_airport_code" => route.dep_airport_code,
			  			"arr_airport_code" => route.arr_airport_code,
			  			"dep_time" => record.dep_time,
			  			"arr_time" => record.arr_time,
			  			"op_days" => record.days_of_operation,
			  			"flight_no"=> record.flight_no,
			  			"min_price" => min_price,
			  			"max_price" => max_price
				  	}
				  end
				end
			end
			if @popular_routes['dom_int'].count == 0 || @popular_routes['dom_int'].nil?
      	@popular_routes['dom_int'] = @popular_routes['int_int'] 
    	elsif @popular_routes['dom_int'].count > 0 
      	@popular_routes['dom_int'] = @popular_routes['dom_int'] + @popular_routes['int_int']
    	end
    	
	  return @popular_routes
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
        "airport_name_ar" => airport.airport_name_ar,
        "city_name" => airport.city_name,
        "city_code" => airport.city_code
      }
    end
    int_airport_records.each do |airport|
      airports["int_airports"] << {
        "airport_name" => airport.airport_name,
        "airport_name_ar" => airport.airport_name_ar,
        "airport_code" => airport.airport_code,
        "city_name" => airport.city_name,
        "city_code" => airport.city_code
      }
    end
    return airports
  end

  def fetch_content 
  	contents = {}
  	model_name = "#{@country_code.titleize}AirlineContent".constantize
  	airline = model_name.find_by(carrier_name: @carrier_name,carrier_code: @carrier_code)

  	overview_content_en = airline.overview_content_en rescue ""
  	meta_title_en = airline.meta_title_en rescue ""
  	meta_description_en = airline.meta_description_en rescue ""
  	overview_content_ar = airline.overview_content_ar rescue ""
  	meta_title_ar = airline.meta_title_ar rescue ""
  	meta_description_ar = airline.meta_description_ar rescue ""
  	contents["overview_content_en"] = overview_content_en
  	contents["meta_description_en"] = meta_description_en
  	contents["meta_title_en"] = meta_title_en
  	contents["overview_content_ar"] = overview_content_ar
  	contents["meta_description_ar"] = meta_description_ar
  	contents["meta_title_en_ar"] = meta_title_ar
  	return contents
  end
 	
	def more_routes_pagination

	end 

  def rhs_top_airlines
  	dom_airlines = AirlineBrand.where(country_code: @country_code).order(brand_routes_count:  :desc).limit(8).pluck(:carrier_code)
  	int_airlines = INTERNATIONAL_AIRLINES[@country_code].take(8)
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
  def rhs_top_schedule_routes_ar
  	dom_routes = UniqueRoute.where(dep_country_code: @country_code,arr_country_code: @country_code).order(weekly_flights_count:  :desc).limit(5)
  	int_routes = UniqueRoute.where("(dep_country_code= ? and arr_country_code!=?)OR(dep_country_code!= ? and arr_country_code=?) ",@country_code,@country_code,@country_code,@country_code).order(weekly_flights_count:  :desc).limit(5)
  	if int_routes.nil? || !int_routes.present?
  		int_routes = UniqueRoute.where("(dep_country_code!= ? and arr_country_code!=?",@country_code,@country_code).order(weekly_flights_count:  :desc).limit(5)
  	end
  	return {dom_routes: dom_routes,int_routes: int_routes}
  end
  
	def booking_footer
		dom_airlines = AirlineBrand.where(country_code: @country_code).order("brand_routes_count desc").limit(8).pluck(:carrier_code).uniq
  		int_airlines = AirlineBrand.where.not(country_code: @country_code).order("brand_routes_count desc").limit(8).pluck(:carrier_code).uniq
	 	# @footer_data = AirlineFooter.first
   #      total_footer_count = eval(@footer_data.airline_footer_en).count
   #      

   #      if @footer_data.current_count == 0 
   #        @footer_data_limit_10 = eval(@footer_data.airline_footer_en).first(10)
   #        @footer_data.update(current_count: @footer_data.current_count+10)
   #      elsif @footer_data.current_count < total_footer_count 
   #        @footer_data_limit_10 = eval(@footer_data.airline_footer_en).drop(@footer_data.current_count).first(10)
   #        binding.pry
   #        @footer_data.update(current_count: @footer_data.current_count+10)
   #      else
   #        @footer_data.update(current_count: 0)
   #         @footer_data_limit_10 = eval(@footer_data.airline_footer_en).first(10)
   #      end
   #      if @footer_data_limit_10.count < 10
   #        @footer_data_limit_10 = eval(@footer_data.airline_footer_en).first(10)
   #      end
   #      @footer_data_limit_10 = @footer_data_limit_10.map{|a|  [url_escape(format_overview_link(a[:carrier_name_en]))+".html", a[:carrier_code]] if a[:carrier_code].present? && a[:carrier_name_en].present?}
   #      footer_airline_data = @footer_data_limit_10.present?  ? @footer_data_limit_10 : []
	 	return {dom_airlines: dom_airlines,int_airlines: int_airlines }
 	end

end