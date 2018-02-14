namespace :city_content_table do 
	desc "update content for specific domains"
	task :update_content do 
		CSV.foreach("public/updated_city_list.csv", :headers=>true).each_with_index do |row,index| 
      begin
        city_code = row[0]
        city_name_en = row[1]
        city_name_hi = row[2]
        city_name_ar = row[3]
        
        city = CityContent.find_or_create_by(:city_code => city_code)
         city.city_name_en = city_name_en
         city.city_name_ar = city_name_ar
         city.city_name_hi = city_name_hi
         city.save
        puts "#{index} - Inserted for City - #{city_code}"
      rescue StandardError => e
        binding.pry
        puts "Exception Occured while adding city data " + e.message
      end
    end
	end
end