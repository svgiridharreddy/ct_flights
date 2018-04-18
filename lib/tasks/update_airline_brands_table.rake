namespace :airline_brand do 
	desc "update airlinebrands table "
	task :update_airlines => :environment do 
		count = 0
		CSV.foreach("public/all_carriers.csv", :headers=>true).each_with_index do |row,index| 
			begin
				carrier_code = row[0]
				carrier_name = row[1]
				country_code = row[2]
				icoa_code = row[5]
				airline = AirlineBrand.find_by(carrier_code: carrier_code,icoa_code: icoa_code)
				if airline.nil? && !airline.present?
					airline = AirlineBrand.find_or_create_by(carrier_code: carrier_code,icoa_code: icoa_code)
					brand_routes_count = PackageFlightSchedule.where(carrier_code: carrier_code).count
					airline.carrier_name = carrier_name.titleize
					airline.country_code = country_code
					airline.brand_routes_count = brand_routes_count
					airline.save!
					puts "#{count+=1} inserted for airline-#{carrier_name}-#{carrier_code}"
				end
			rescue StandardError => e 
				binding.pry
			end

		end

	end
end