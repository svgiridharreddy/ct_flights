require_relative './support/constants.rb'

class FlightScheduleService
	def initialize(args)
	    @dep_city_code = args[:dep_city_code]
	    @arr_city_code = args[:arr_city_code]
	    @dep_city_name = args[:dep_city_name]
	    @arr_city_name = args[:arr_city_name]
	    @dep_country_code = args[:dep_country_code]
	    @arr_country_code = args[:arr_country_code]
	    @country_code = args[:country_code]
	    @domestic_carrier_codes = AirlineBrand.where(country_code: @country_code).pluck("distinct(carrier_code)") 
  	end

    def schedule_layout_values
    	route_values = {}
    	dep_city_name_formated = url_escape(@dep_city_name)
    	arr_city_name_formated = url_escape(@arr_city_name)
    	return_url = arr_city_name_formated +"-"+dep_city_name_formated +"-flights.html"
			top_dom_cc = AirlineBrand.where("country_code='IN'").order("brand_routes_count desc").limit(8).pluck(:carrier_code)
			top_dom_airlines = top_dom_cc.map{|cc| I18n.t("airlines.#{cc}")}
			top_int_cc = AirlineBrand.where("country_code!='IN'").order("brand_routes_count desc").limit(8).pluck(:carrier_code)
			top_int_airlines = top_int_cc.map{|cc| I18n.t("airlines.#{cc}") } 
			route_values["return_url"] = return_url
			route_values["dep_city_name_formated"] = dep_city_name_formated
			route_values["arr_city_name_formated"] = arr_city_name_formated
			route_values["top_dom_airlines"] = top_dom_cc
			route_values["top_int_airlines"] = top_int_cc
			return route_values
    end
    def fetch_content
    	
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
end