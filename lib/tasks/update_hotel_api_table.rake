namespace :store_hotel_api do 
	desc "store hoatels data"
	task store_data: :environment do
		airports = Airport.all
		airports.each do |airport|
			if airport.country_name.present? && airport.city_name.present?
				url = "http://54.169.90.61/hotels/api/"+airport.country_name.gsub(' ','-').downcase+"/"+airport.city_name.gsub(' ','-').downcase+".json"
				p url
				res = HTTParty.get(url)
				if res.code == 200
					resp_body = JSON.parse(res.body)
					current_iteration_count = 0
					total_iteration_count = resp_body["localities"].count/5
					HotelApi.create(city_name: airport.city_name,country_code: airport.country_code,country_name: airport.country_name,star_data:resp_body["stars"].to_s,hotel_data:resp_body["hotels"].to_s,local_cities_data:resp_body["localities"].to_s,properties:resp_body["properties"].to_s,local_activities:resp_body["local_activities"].to_s,current_iteration_count:current_iteration_count,total_iteration_count:total_iteration_count,pop_json_data:resp_body["localities"].to_s)
					sleep(0.5)
				end
			end
		end
	end
	task store_reach_data: :environment do
		file = File.read("city_data.csv")
		csv  = CSV.parse(file,:headers => true)
		csv.each do |row|
			city_name = row["city_name"]
			hotels= HotelApi.where(city_name:city_name)
			hotels.update_all(wayto_go: row['data'])
			p row["city_name"]
		end
	end
end

