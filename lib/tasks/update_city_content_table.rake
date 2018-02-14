namespace :city_content_table do 
	desc "update content for specific domains"
	task :update_content => :environment do 
    count = 0
		CSV.foreach("public/updated_city_list.csv", :headers=>true).each_with_index do |row,index| 
      begin
        # city_code = row[0]
        # city_code = "BLR"
        # city_name_en = row[1]
        # city_name_en = "Bangalore"
       
        content_in_en = File.open("#{Rails.root}/public/india/en/schedule/city_content/#{city_name_en}-#{city_code}.txt","r:bom|utf-8").read.force_encoding("UTF-8") rescue nil
        if content_in_en.present? && !content_in_en.nil?
          city = CityContent.find_by(:city_code => city_code)
          city.content_in_en = content_in_en
          city.save!
          puts "#{count+=1} - Inserted for City - #{city_code}"
        end
      rescue StandardError => e
        binding.pry
        puts "Exception Occured while adding city data " + e.message
      end
    end
	end
end