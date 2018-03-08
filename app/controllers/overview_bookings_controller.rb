class OverviewBookingsController < ApplicationController

	def booking_values
		domain = request.domain
		application_processor = ApplicationProcessor.new
		@country_code = application_processor.host_country_code(domain)[0]
		@country_name = application_processor.host_country_code(domain)[1]
		@language = params[:lang].nil? ? 'en' : params[:lang]
		airline_name = params[:airline]
		carrier_name = params[:airline].gsub("-",' ').gsub("airlines",'').titleize.strip
		carrier_name_with_airline = carrier_name + " Airlines"			
		airline = AirlineBrand.find_by("carrier_name='#{carrier_name}' OR carrier_name ='#{carrier_name_with_airline}'")
		@carrier_name = airline.carrier_name
		@carrier_code = airline.carrier_code
		@section = airline.country_code == 'IN' ? "IN-dom" : 'IN-int'
		@airline_details = { carrier_code: @carrier_code,
											  carrier_name: @carrier_name,
											  section: @section,
												country_code: @country_code
											  }
		flight_booking_service = FlightBookingService.new @airline_details
		popular_routes = flight_booking_service.airline_popular_routes
	  section =  @section.include?("dom") ? "dom" : "int"
	  binding.pry
		partial = "overview_bookings/#{@language}/overview_#{@country_code.downcase}_#{section}_#{@language.downcase}"
		render partial,locals: {popular_routes: popular_routes}
	end
end
