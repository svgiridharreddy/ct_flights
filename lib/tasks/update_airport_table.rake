namespace :airport_table do 
	desc "update airport_names"
	task update_airprot_names: :environment do 
		CSV.foreach("public/airport_names_with_ar.csv", :headers=>true).each_with_index do |row,index| 
			begin
				airport_code = row[0]
				airport_name_en = row[1]
				country_code = row[2]
				airport_name_ar = row[3]	
				binding.pry
				airport = Airport.find_or_create_by(airport_code: airport_code)
				airport.airport_name = airport_name_en rescue ""
				airport.country_code = country_code rescue ""
				airport.airport_name_ar = airport_name_ar rescue ""
				airport.save!
				puts "#{index+=1}  updated airport-#{airport_code}"
			rescue StandardError => e 
				binding.pry
				e.message
				e.backtrace
			end
		end
	end
end