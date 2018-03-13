namespace :airline_content_tables do 

	desc "create airlines in table"
	task :create_in_airines_content_data => :environment do 
		# uniqie_content_carrier_codes = ["X01", "US", "LX", "SU", "AY", "B6", "U2", "X03", "S2", "UO", "DL", "UA", "9W", "WY", "X05", "TG", "SQ", "PK", "LH", "CX", "MU", "LB", "AC", "G9", "NK", "CI", "KL", "AF", "UL", "KU", "SG", "BA", "JQ", "EY", "UK", "PR", "Red ", "EK", "GF", "MK", "MH", "TK", "VS", "CO", "KQ", "AK", "RT", "J9", "A3", "2S", "F9", "SA", "X02 ", "AI", "6E", "SV", "IT", "G8", "AA", "X06", "PG", "IX", "RA", "IT", "QR", "MS", "QF", "K", "OS", "FL", "FZ", "ET", "VA", "KE", "FJ", "FJ", "TR", "HU", "IC", "X02", "VY", "HPR"]
		airlines = AirlineBrand.where(carrier_code: carrier_codes)
		puts "started updating table"
		count = 0

		airlines.each do |airline|
			begin 
				country_code = "IN".titleize
				modle_name = "#{country_code}AirlineContent".constantize
				brand = modle_name.find_or_create_by(carrier_code: airline.carrier_code,icoa_code: airline.icoa_code)
				# carrier_name = 'Jet Airways'
				carrier_name = airline.carrier_name
				carrier_code = airline.carrier_code
				# carrier_code ='9W'
				unique_content = File.read("#{Rails.root}/public/india/en/booking/in_airline_content/#{carrier_name.split(' ').join('-')}-#{carrier_code}.txt") rescue nil

				if unique_content.present? && !unique_content.nil?
					overview_content_en = unique_content 
				else
					key = "#{country_code.downcase}_#{carrier_code}_content"
          overview_content_en = I18n.t("airline_brand_content.#{key}") rescue ""
				end
				brand.overview_content_en = overview_content_en
				brand.country_code = airline.country_code
				brand.carrier_name = airline.carrier_name
				brand.save!
				puts "#{count+=1} updated for airline-#{carrier_code}-#{carrier_name}"
				# customer_support_content_en = File.read("#{Rails.root}/public/india/en/booking/customer_support/#{carrier_name.split(' ').join('-')}-#{carrier_code}.txt") rescue nil
				# baggage_content_en = File.read("#{Rails.root}/public/india/en/booking/baggages_page/#{carrier_name.split(' ').join('-')}-#{carrier_code}.txt") rescue nil
				# cancellation_content_en = File.read("#{Rails.root}/public/india/en/booking/cancellation_page/#{carrier_name.split(' ').join('-')}-#{carrier_code}.txt") rescue nil
				# pnr_content_en = File.read("#{Rails.root}/public/india/en/booking/pnr_contnet_en/#{carrier_name.split(' ').join('-')}-#{carrier_code}.txt") rescue nil

				# meta_title_en = File.read("#{Rails.root}/public/india/en/booking/airlines_title_desc/#{carrier_name.downcase.split(' ').join('-')}-title.txt") rescue nil
				# meta_title_en = File.read("#{Rails.root}/public/india/en/booking/airlines_title_desc/#{carrier_name.downcase.split(' ').join('-')}-description.txt") rescue nil

				# brand.meta_title_en = meta_title_en
				# brand.meta_description_en = meta_description_en
				# brand.overview_content_en = overview_content_en
				# brand.customer_support_content_en = customer_support_content_en
				# brand.baggage_content_en = baggage_content_en
				# brand.cancellation_content_en = cancellation_content_en
				# brand.country_code = airline.country_code
				# brand.carrier_name = airline.carrier_name
				# brand.pnr_content_en = pnr_content_en
				# brand.save!
				
			rescue StandardError=>e 
				e.message
				e.backtrace
			end
		end
	end
end