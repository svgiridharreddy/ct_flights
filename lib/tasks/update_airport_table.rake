namespace :airport_table do 
	desc "update airport_names"
	task update_airprot_names: :environment do 
		CSV.foreach("#{Rails.root}/public/updated_airports_list.csv", :headers=>true).each_with_index do |row,index| 
			begin
				city_code  = row[0]
				airport_code = row[1]
				airport_name_en = row[2]
				airport_name_ar = row[3]	
				airport = Airport.find_or_create_by(airport_code: airport_code,city_code: city_code)
				airport.city_code = city_code
				airport.airport_name = airport_name_en.to_s rescue ""
				airport.airport_name_ar = airport_name_ar.to_s rescue ""
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