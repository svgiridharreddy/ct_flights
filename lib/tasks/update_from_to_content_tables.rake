namespace :update_from_to_content do 
	desc "create and update from and to content for India"
	task :india => :environment do 
		count = 0
		
		CSV.foreach("#{Rails.root}/public/updated_city_list.csv",:headers=> true).each_with_index do |row,index|
			begin
				city_code = row[0]
				city_name_en = row[1]
				city = InFromToContent.find_or_create_by(city_code: city_code,city_name: city_name_en)
				from_city_content = File.open("#{Rails.root}/public/india/en/from-to/from_cities/Flights-from-#{city_name_en}.txt","r:bom|utf-8").read.force_encoding("UTF-8") rescue ''
				to_city_content = File.open("#{Rails.root}/public/india/en/from-to/to-cities/Flights-to-#{city_name_en}.txt","r:bom|utf-8").read.force_encoding("UTF-8") rescue ''
				city.en_from_content = from_city_content
				city.en_to_content = to_city_content
				puts "#{count+=1} inserted for city-#{city_name_en}"
			rescue StandardError => e
				e.message
				e.backtrace
			end
		end
		# city.en_from_content = 
		# city_en_to_content = 
	end
end