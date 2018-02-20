namespace :airport_table do 

	task :get_extra_airports => :environment do 
		present_count = 0 
		absent_count = 0
		CSV.open("#{Rails.root}/not_present_airports.csv","w") do |csv|
	        attributes = %w( airport_code airport_name country_code country_name status)
	        csv << attributes
	     count = 0

			CSV.foreach("public/Airport LIst.csv", :headers=>true).each_with_index do |row,index| 
			# airport_table:get_extra_airports
			airport_code = row[0]
			airport_name = row[4]
			country_code = row[5]
			country_name = row[7]
			status = row[13]
			airport = Airport.find_by(airport_code: airport_code)
			if airport.present? && !airport.nil?
					csv << [airport_code,airport_name,country_code,country_name,status]
					absent_count+=1
			end
			# else
			# 	CSV.open("#{Rails.root}/not_present_airprots.csv","w") do |csv|
	  #       attributes = %w( airport_code airport_name country_code country_name status)
	  #       csv << attributes
			# 		csv << [airport_code,airport_name,country_code,country_name,status]
			# 		absent_count+=1 
			# 	end
			puts "#{count+=1}-searched airports"
			end
		end
		puts "total present count = #{present_count} && absent_count = #{absent_count}"
	end	
end