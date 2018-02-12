namespace :airline_brand do 
	desc "update airlinebrands table "
	task :create_airlines => :environment do 
		CSV.foreach("public/final_airline.csv", :headers=>true).each_with_index do |row,index| 
			begin
				carrier_code = row[0]
				icao_code = row[1]
				carrier_name = row[2]
				base_airport = row[3]
				country = row[4]
				brand_routes_count = row[5]
				country_code = row[6]
				publish_status = row[7]
				airline = AirlineBrand.find_or_create_by(carrier_code: carrier_code,icoa_code: icao_code)
				airline.carrier_name = carrier_name
				airline.base_airport = base_airport
				airline.country = country
				airline.brand_routes_count = brand_routes_count
				airline.country_code = country_code
				airline.publish_status = publish_status
				airline.save!
				puts "#{index} inserted for airline-#{carrier_name}-#{carrier_code}"
			rescue StandardError => e 
				binding.pry
			end

		end

	end
end