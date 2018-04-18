require "csv"
# =========== run rake in background =============
# nohup bundle exec rake unique_routes_table:dep_and_arr_cities_name QUEUE="*" --trace > rake.out 2>&1 &

namespace :unique_routes_table do 
	desc "update dep_city_names and arr_city_names in unique_routes table"
	task :dep_and_arr_cities_name => :environment do 
		CSV.foreach("public/updated_city_list.csv", :headers=>true).each_with_index do |row,index| 
  		begin
        city_code = row[0]
        city_name_ar = row[3]

        dep_cities = UniqueRoute.where(dep_city_code: row[0])

        dep_cities.each do |dep_city|
        	dep_city.dep_city_name_ar = city_name_ar
        	dep_city.save!
        end

        arr_cities = UniqueRoute.where(arr_city_code: row[0])
        arr_cities.each do |arr_city|
        	arr_city.arr_city_name_ar = city_name_ar
        	arr_city.save!
        end
        puts "#{index}-city_code=#{city_code} with dep_city_count=#{dep_cities.count} and arr_city_count=#{arr_cities.count}"
      rescue StandardError => e
        	binding.pry
      end
		end
	end
  desc "update route url in unique routes table"
  task :update_schedule_url => :environment do 
    # routes = UniqueRoute.all
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
    routes = UniqueRoute.where()
    count = 0
    begin 
      routes.find_each do |route|
        
        route_url_format = url_escape("#{route.dep_city_name}-#{route.arr_city_name}")
        route.schedule_route_url = route_url_format
        route.save!
        puts "#{count+=1}-#{route_url_format} has been updated!"
      end
    rescue StandardError => e 
      binding.pry
    end
  end

  task get_city_codes: :environment do 
    CSV.open("#{Rails.root}/update_calendar_routes.csv","w") do |csv|
      attributes = %w( dep_city_code arr_city_code url)
          csv << attributes
      CSV.foreach("#{Rails.root}/public/to_update_calendar_routes.csv", :headers=>true).each_with_index do |row,index|
        begin
          url = row[0].split("/")[2].gsub("-flights.html",'')
          route = UniqueRoute.find_by(schedule_route_url: url)
          dep_city_code = route.dep_city_code
          arr_city_code = route.arr_city_code
          url = row[0]
          csv << [dep_city_code,arr_city_code,url]
        rescue 
          binding.pry
        end
      end
    end
  end
  task :compare_hop_routes => :environment do
    routes = UniqueHopRoute.all
    routes.each_with_index do |r,index|
      route=UniqueRoute.find_by(schedule_route_url: r.url)
      if route.nil? || !route.present?
        puts "#{index}-#{r.url},dep_city_code='#{r.dep_city_code}' and arr_city_code='#{r.arr_city_code}'"
      end
    end
  end
end 
