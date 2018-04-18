class OverviewBookingsController < ApplicationController
	include ApplicationHelper
	def booking_values
		domain = request.domain
		application_processor = ApplicationProcessor.new
		@country_code = application_processor.host_country_code(domain)[0]
		@country_name = application_processor.host_country_code(domain)[1]
		@language = params[:lang].nil? ? 'en' : params[:lang]
		@host_name = application_processor.host_name(@country_code)
		@page_type = "booking-overview"
		airline_name = params[:airline] 
		carrier_name = params[:airline].gsub("-",' ').gsub(/\d/,'').gsub("airlines",'').titleize.strip
		carrier_name_with_airline = carrier_name + " Airlines"			
		page_no = airline_name.gsub(/[^0-9]/,'').to_i || 0
		page_name = airline_name.gsub(/-\d/,'')
		@file_name = airline_name+".html"
		airline = AirlineBrand.find_by("carrier_name='#{carrier_name}' OR carrier_name ='#{carrier_name_with_airline}'")
		if airline.nil? || !airline.present?
			redirect_to "#{@host_name}/flight-booking/domestic-airlines.html" and return
		end
		check_domain = check_domain(@language,@country_code)
		if check_domain
			lang = @language == "en" ? "" : "#{@language}"
			if @country_code == "IN"
					redirect_to "#{@host_name}/flight-schedule/flight-schedules-domestic.html" and return
			else
				redirect_to "#{@host_name}/#{lang}/flight-schedule/flight-schedules-domestic.html" and return
			end
		end

		@carrier_name = airline.carrier_name
		@carrier_code = airline.carrier_code
		@carrier_name_ar = I18n.with_locale(:ar) {I18n.t("airlines.#{@carrier_code}")}
		file_paths = YAML.load(File.read('config/application.yml'))[Rails.env]
		@assets_path = file_paths["assets_path"]
		@section = airline.country_code == @country_code ? "#{@country_code}-dom" : "#{@country_code}-int"
		@airline_details = {  carrier_code: @carrier_code,
							  					carrier_name: @carrier_name,
							  					section: @section,
							  					country_code: @country_code,
							  					language: @language
											  }

		customer_support_airlines = ['AI','CX','TG','SQ','G8','AK','UK','SG','G9','9W','LH','EY','BA','6E','QR','EK']
    baggages_airlines = ['AI','TR','EY','SG','QR','AK','9W','G9','6E','FZ','BA','LH','UK','CX','SQ','UA','UL','G8','TG','MH','EK','WY']
    customer_support = @country_code=='IN' ? customer_support_airlines.include?(@carrier_code) : false
    baggages = @country_code=='IN' ? baggages_airlines.include?(@carrier_code) : false
		flight_booking_service = FlightBookingService.new @airline_details
		airline_more_routes =  flight_booking_service.airline_more_routes
		pagination = custom_pagination(page_no,airline_more_routes,page_name)
		if page_no == 0
			popular_routes = flight_booking_service.airline_popular_routes
			content = flight_booking_service.fetch_content
	  end
	  header_routes = flight_booking_service.header_airline_routes
		header_airports = flight_booking_service.top_dom_int_airports
		rhs_airlines = flight_booking_service.rhs_top_airlines
		rhs_schedule_routes = @language=="ar" ? flight_booking_service.rhs_top_schedule_routes_ar : flight_booking_service.rhs_top_schedule_routes
		booking_footer = flight_booking_service.booking_footer
	  section =  @section.include?("dom") ? "dom" : "int"
		partial = "bookings/overview/#{@language}/overview_#{@country_code.downcase}_#{section}_#{@language.downcase}"
		render partial,locals: {popular_routes: popular_routes,header_routes: header_routes,flight_file_name: @file_name,application_processor: application_processor,page_type: 'flight-booking',header_airports: header_airports,customer_support: customer_support,baggages: baggages,rhs_airlines: rhs_airlines,rhs_schedule_routes: rhs_schedule_routes,content: content,booking_footer: booking_footer,pagination: pagination}
	end

	def url_escape(url_string)
    unless url_string.blank?
      result = url_string.encode("UTF-8", :invalid => :replace, :undef => :replace).to_s
      result = result.gsub(/[\/]/,'-')
      result = result.gsub(/[^\x00-\x7F]+/, '') # Remove anything non-ASCII entirely (e.g. diacritics).
      result = result.gsub(/[^\w_ \-]+/i,   '') # Remove unwanted chars.
      result = result.gsub(/[ \-]+/i,      '-') # No more than one of the separator in a row.
      result = result.gsub(/^\-|\-$/i,      '') # Remove leading/trailing separator.
      result = result.downcase
    end
  end

  def format_overview_link(carrier_name)
    unless carrier_name.blank?
      if(carrier_name.downcase.include?('airlines') || carrier_name.downcase.include?('airline')|| carrier_name.downcase.include?('air lines'))
        result = carrier_name.downcase
        result = result.gsub("airlines","")
        result = result.gsub("airline","")
        result = result.gsub("air lines","")
        result = result.strip.downcase.gsub(" ", "-")
        result = result+"-airlines"
      else
        result = carrier_name.downcase.gsub(" ","-")+ "-airlines"
      end
    end
  end
end
