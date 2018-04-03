require_relative './support/constants.rb'

class ApplicationProcessor

  def get_hotel_details(city_name, destination_country_code = nil)
    if city_name == 'Kuwait'
      city_name = 'Kuwait City'
    end
    hotel_information = Hash.new
    hotels_hash = Hash.new
    hotels_updated_hash = Hash.new
    populer_hotels = Array.new
    if !destination_country_code.blank?
      hotels_data = PackageHotel.where("city_name = ? and country_code = ? and tar_rating >= ? and hotel_image != ''",city_name, destination_country_code, 3.5).select("distinct hotel_id, hotel_name, hotel_area, tar_rating, country_code, tar_reviews, hotel_image, image_full_path, city_name, hotel_area, star").order("tar_rating desc, tar_reviews desc, hotel_name")

      hotels_count = PackageHotel.where("city_name = ? and country_code = ? and image_full_path != ''", city_name, destination_country_code).select("distinct hotel_id")
    else
      hotels_data = PackageHotel.where("city_name = ? and tar_rating >= ? and hotel_image != ''",city_name, 3.5).select("distinct hotel_id, hotel_name, hotel_area, tar_rating, country_code, tar_reviews, hotel_image, image_full_path, city_name, hotel_area, star").order("tar_rating desc, tar_reviews desc, hotel_name")

      hotels_count = PackageHotel.where("city_name = ? and image_full_path != ''", city_name).select("distinct hotel_id")
    end
    five_start_filtered_hotels = hotels_data.select{|a| a.star == 5 }
    four_start_filtered_hotels = hotels_data.select{|a| a.star == 4 }
    three_start_filtered_hotels = hotels_data.select{|a| a.star == 3}

    hotels_hash[5] = five_start_filtered_hotels[0..3] unless five_start_filtered_hotels.blank?
    hotels_hash[4] = four_start_filtered_hotels[0..3] unless four_start_filtered_hotels.blank?
    hotels_hash[3] = three_start_filtered_hotels[0..3] unless three_start_filtered_hotels.blank?

    unless hotels_hash.blank?
      hoter_5_start = []
      unless hotels_hash[5].blank?
        hotels_hash[5].each do |hotel_info|
          hotel = {}
          hotel = hotel_info.attributes
          unless hotel["country_code"].blank?
            hotel["hotel_url"]  = "#{host_name(destination_country_code)}/hotels/results?city=#{city_name}&country=#{hotel["country_code"]}&area=&poi=&hotelName=#{CGI.escape(hotel["hotel_name"])}&dest_code=&chk_in=&chk_out=&adults1=1&children1=0&num_rooms=1"
          else
            hotel["hotel_url"]  = "#{host_name(destination_country_code)}/hotels/results?city=#{city_name}&country=&area=&poi=&hotelName=#{CGI.escape(hotel["hotel_name"])}&dest_code=&chk_in=&chk_out=&adults1=1&children1=0&num_rooms=1"
          end
          hotel["image_full_path"] = hotel["image_full_path"].gsub('.JPG','.jpg')
          hoter_5_start.push(hotel)
        end
        hotels_updated_hash["5"] = hoter_5_start
      end

      hoter_4_start = []
      unless hotels_hash[4].blank?
        hotels_hash[4].each do |hotel_info|
          hotel = {}
          hotel = hotel_info.attributes
          unless hotel["country_code"].blank?
            hotel["hotel_url"]  = "#{host_name(destination_country_code)}/hotels/results?city=#{city_name}&country=#{hotel["country_code"]}&area=&poi=&hotelName=#{CGI.escape(hotel["hotel_name"])}&dest_code=&chk_in=&chk_out=&adults1=1&children1=0&num_rooms=1"
          else
            hotel["hotel_url"]  = "#{host_name(destination_country_code)}/hotels/results?city=#{city_name}&country=&area=&poi=&hotelName=#{CGI.escape(hotel["hotel_name"])}&dest_code=&chk_in=&chk_out=&adults1=1&children1=0&num_rooms=1"
          end
          hotel["image_full_path"] = hotel["image_full_path"].gsub('.JPG','.jpg')
          hoter_4_start.push(hotel)
        end
        hotels_updated_hash["4"] = hoter_4_start
      end

      hoter_3_start = []
      unless hotels_hash[3].blank?
        hotels_hash[3].each do |hotel_info|
          hotel = {}
          hotel = hotel_info.attributes
          unless hotel["country_code"].blank?
            hotel["hotel_url"]  = "#{host_name(destination_country_code)}/hotels/results?city=#{city_name}&country=#{hotel["country_code"]}&area=&poi=&hotelName=#{CGI.escape(hotel["hotel_name"])}&dest_code=&chk_in=&chk_out=&adults1=1&children1=0&num_rooms=1"
          else
            hotel["hotel_url"]  = "#{host_name(destination_country_code)}/hotels/results?city=#{city_name}&country=&area=&poi=&hotelName=#{CGI.escape(hotel["hotel_name"])}&dest_code=&chk_in=&chk_out=&adults1=1&children1=0&num_rooms=1"
          end
          hotel["image_full_path"] = hotel["image_full_path"].gsub('.JPG','.jpg')
          hoter_3_start.push(hotel)
        end
      end
    end
    hotels_updated_hash["3"] = hoter_3_start

    hotel_information["hotels_list"] = hotels_updated_hash
    hotel_information["destination_name"] = city_name
    hotel_information["hotel_count"] = hotels_count.length unless hotels_count.blank?
    unless hoter_5_start.blank? && hoter_4_start.blank? && hoter_3_start.blank?
      hotel_information["popular_hotels"] = hoter_5_start[0..1] + hoter_4_start[0..1] + hoter_3_start[0..1]
    end
    return hotel_information
  end

  def get_hotel_rhs_links_details(arr_city_name, arr_country_name)
    if arr_city_name == 'Kuwait'
      arr_city_name = 'Kuwait City'
    end
    hotels_data = PackageHotel.where("city_name = ?", arr_city_name).select("hotel_id, star, country_code").distinct

    five_start_hotels = four_start_hotels = three_start_hotels = two_start_hotels = one_start_hotels = 0

    five_start_hotels = hotels_data.select{|a| a.star == 5 }
    four_start_hotels = hotels_data.select{|a| a.star == 4 }
    three_start_hotels = hotels_data.select{|a| a.star == 3}
    two_start_hotels = hotels_data.select{|a| a.star == 2 }
    one_start_hotels = hotels_data.select{|a| a.star == 1 }

    hotel_details ={}
    hotel_details['five_count'] = five_start_hotels.count
    hotel_details['four_count'] = four_start_hotels.count
    hotel_details['three_count'] = three_start_hotels.count
    hotel_details['two_count'] = two_start_hotels.count
    hotel_details['one_count'] = one_start_hotels.count
    hotel_details['hotel_url'] = "#{host_name(arr_country_name)}/hotels/#{url_escape(arr_country_name)}/#{url_escape(arr_city_name)}/"
    hotel_details['city_name'] = arr_city_name.downcase.delete(' ') if arr_city_name.present?
    return hotel_details
  end

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

  def host_name(country_code)
    # puts "country_code - #{country_code}"
    if country_code == 'AE'
      return 'https://www.cleartrip.ae'
    elsif country_code == 'KW'
      return 'https://kw.cleartrip.com'
    elsif country_code == 'SA'
      return 'https://www.cleartrip.sa'
    elsif country_code == 'BH'
      return 'https://bh.cleartrip.com'
    elsif country_code == 'QA'
      return 'https://qa.cleartrip.com'
    elsif country_code == 'OM'
      return 'https://om.cleartrip.com'
    elsif country_code == 'IN'
      return 'https://www.cleartrip.com'
    else
      ''
    end
  end

    def host_country_code(host)
    # host = host || ""
    # puts "country_code - #{country_code}"
    if host == 'https://www.cleartrip.ae'
      return ['AE',"United Arab Emirates"]
    elsif host == 'https://kw.cleartrip.com'
      return ['KW',"Kuwait"]
    elsif host == 'https://www.cleartrip.sa'
      return ['SA',"Saudi Arabia"]
    elsif host == 'https://bh.cleartrip.com'
      return ['BH',"Bahrain"]
    elsif host == 'https://qa.cleartrip.com'
      return ['QA',"Qatar"]
    elsif host == 'https://om.cleartrip.com'
      return ['OM',"Oman"]
    elsif host == 'https://www.cleartrip.com'
      return ['IN',"India"]
    else
      return ['IN',"India"]
    end
  end

  def currency_code(country_code)
    if country_code == 'AE'
      return 'AED'
    elsif country_code == 'KW'
      return 'KWD'
    elsif country_code == 'SA'
      return 'SAR'
    elsif country_code == 'BH'
      return 'BHD'
    elsif country_code == 'QA'
      return 'QAR'
    elsif country_code == 'OM'
      return 'OMR'
    elsif country_code == 'IN'
      return '₹'
    else
      ''
    end
  end

  def currency_name(country_code)
    if country_code == 'AE'
      return 'AED'
    elsif country_code == 'KW'
      return 'KWD'
    elsif country_code == 'SA'
      return 'SAR'
    elsif country_code == 'BH'
      return 'BHD'
    elsif country_code == 'QA'
      return 'QAR'
    elsif country_code == 'OM'
      return 'OMR'
    elsif country_code == 'IN'
      return 'Rs.'
    else
      ''
    end
  end
end
