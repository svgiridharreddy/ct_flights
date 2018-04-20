  module ApplicationHelper

    def seo_header
      meta_title = meta_keywords = meta_description = ""
      meta_info = SEO_META[@page_type]
      host = get_domain
      case @page_type 
      when "flight-schedule"
        if @language == "ar"
          title = (@title_min_price.present? && @title_min_price!=0) ? "title_with_price" : "title_without_price"
          meta_title = meta_info["#{@country_code.downcase}_#{@section[3..5]}"]["#{@language.downcase}"]["#{title}"] %{dep_city_name: @dep_city_name_ar,arr_city_name: @arr_city_name_ar,price: @title_min_price}
          meta_description = meta_info["#{@country_code.downcase}_#{@section[3..5]}"]["#{@language.downcase}"]["description"] %{dep_city_name: @dep_city_name_ar,arr_city_name: @arr_city_name_ar,host: host}
          meta_keywords = meta_info["#{@country_code.downcase}_#{@section[3..5]}"]["#{@language.downcase}"]["keywords"] %{dep_city_name: @dep_city_name_ar,arr_city_name: @arr_city_name_ar}
          amp_url = meta_info["#{@country_code.downcase}_#{@section[3..5]}"]["#{@language.downcase}"]["amp_url"] %{dep_city_name_formated: @dep_city_name_formated,arr_city_name_formated: @arr_city_name_formated}
        else
          title = (@title_min_price.present? && @title_min_price!=0) ? "title_with_price" : "title_without_price"
          meta_title = meta_info["#{@country_code.downcase}_#{@section[3..5]}"]["#{@language.downcase}"]["#{title}"] %{dep_city_name: @dep_city_name,arr_city_name: @arr_city_name,price: @title_min_price}
          meta_description = meta_info["#{@country_code.downcase}_#{@section[3..5]}"]["#{@language.downcase}"]["description"] %{dep_city_name: @dep_city_name,arr_city_name: @arr_city_name}
          meta_keywords = meta_info["#{@country_code.downcase}_#{@section[3..5]}"]["#{@language.downcase}"]["keywords"] %{dep_city_name: @dep_city_name,arr_city_name: @arr_city_name}
          amp_url = meta_info["#{@country_code.downcase}_#{@section[3..5]}"]["#{@language.downcase}"]["amp_url"] %{dep_city_name_formated: @dep_city_name_formated,arr_city_name_formated: @arr_city_name_formated}
        end
      when "from"
        if @language == "ar"
          meta_title = meta_info["#{@country_code.downcase}_from"]["#{@language.downcase}"]["title"] %{city_name: @city_name_ar}
          meta_description = meta_info["#{@country_code.downcase}_from"]["#{@language.downcase}"]["description"] %{city_name: @city_name_ar}
          meta_keywords = meta_info["#{@country_code.downcase}_from"]["#{@language.downcase}"]["keywords"] %{city_name: @city_name_ar} rescue ""
          amp_url = ""
        else 
          meta_title = meta_info["#{@country_code.downcase}_from"]["#{@language.downcase}"]["title"] %{city_name: @city_name}
          meta_description = meta_info["#{@country_code.downcase}_from"]["#{@language.downcase}"]["description"] %{city_name: @city_name}
          meta_keywords = meta_info["#{@country_code.downcase}_from"]["#{@language.downcase}"]["keywords"] %{city_name: @city_name} rescue ""
          amp_url = ""
        end
      when "to"
        if @language == "ar"
          meta_title = meta_info["#{@country_code.downcase}_to"]["#{@language.downcase}"]["title"] %{city_name: @city_name_ar}
          meta_description = meta_info["#{@country_code.downcase}_to"]["#{@language.downcase}"]["description"] %{city_name: @city_name_ar}
          meta_keywords = meta_info["#{@country_code.downcase}_to"]["#{@language.downcase}"]["keywords"] %{city_name: @city_name_ar} rescue ""
          amp_url = ""
        else
          meta_title = meta_info["#{@country_code.downcase}_to"]["#{@language.downcase}"]["title"] %{city_name: @city_name}
          meta_description = meta_info["#{@country_code.downcase}_to"]["#{@language.downcase}"]["description"] %{city_name: @city_name}
          meta_keywords = meta_info["#{@country_code.downcase}_to"]["#{@language.downcase}"]["keywords"] %{city_name: @city_name} rescue ""
          amp_url = ""
        end
      when "booking-overview"
        if @language == "ar"
          meta_title = meta_info["#{@country_code.downcase}"]["#{@language.downcase}"]["#{@section[3..5]}"]["title"] %{airline_name: @carrier_name_ar}
          meta_description = meta_info["#{@country_code.downcase}"]["#{@language.downcase}"]["#{@section[3..5]}"]["description"] %{airline_name: @carrier_name_ar}
          meta_keywords = meta_info["#{@country_code.downcase}"]["#{@language.downcase}"]["#{@section[3..5]}"]["keywords"] %{airline_name: @carrier_name_ar} rescue ""
          amp_url = meta_info["#{@country_code.downcase}"]["#{@language.downcase}"]["amp_url"] %{file_name: @file_name}
        else
          meta_title = meta_info["#{@country_code.downcase}"]["#{@language.downcase}"]["#{@section[3..5]}"]["title"] %{carrier_name: @carrier_name}
          meta_description = meta_info["#{@country_code.downcase}"]["#{@language.downcase}"]["#{@section[3..5]}"]["description"] %{carrier_name: @carrier_name}
          meta_keywords = meta_info["#{@country_code.downcase}"]["#{@language.downcase}"]["#{@section[3..5]}"]["keywords"] %{carrier_name: @carrier_name} rescue ""
          amp_url = meta_info["#{@country_code.downcase}"]["#{@language.downcase}"]["amp_url"] %{file_name: @file_name}
        end
      when "flight-tickets"
        title = (@title_min_price.present? && @title_min_price!=0) ? "title_with_price" : "title_without_price"
        if @language == "ar"
          meta_title = meta_info["#{@country_code.downcase}"]["#{@language.downcase}"]["#{@section[3..5]}"]["title"] %{dep_city_name: @dep_city_name_ar,arr_city_name: @arr_city_name_ar,dep_city_code: @route.dep_city_code,arr_city_code: @route.arr_city_code}
          meta_description = meta_info["#{@country_code.downcase}"]["#{@language.downcase}"]["#{@section[3..5]}"]["description"] %{dep_city_name: @dep_city_name,arr_city_name: @arr_city_name}
          meta_keywords = meta_info["#{@country_code.downcase}"]["#{@language.downcase}"]["#{@section[3..5]}"]["keywords"]  %{dep_city_name: @dep_city_name,arr_city_name: @arr_city_name}
          amp_url = meta_info["#{@country_code.downcase}"]["#{@language.downcase}"]["amp_url"] %{file_name: @file_name}
        else
          meta_title = meta_info["#{@country_code.downcase}"]["#{@language.downcase}"]["#{@section[3..5]}"]["title"] %{dep_city_name: @dep_city_name,arr_city_name: @arr_city_name,dep_city_code: @route.dep_city_code,arr_city_code: @route.arr_city_code,min_pirce: @title_min_price}
          meta_description = meta_info["#{@country_code.downcase}"]["#{@language.downcase}"]["#{@section[3..5]}"]["description"] %{dep_city_name: @dep_city_name,arr_city_name: @arr_city_name}
          meta_keywords = meta_info["#{@country_code.downcase}"]["#{@language.downcase}"]["#{@section[3..5]}"]["keywords"] %{dep_city_name: @dep_city_name,arr_city_name: @arr_city_name}
          amp_url = meta_info["#{@country_code.downcase}"]["#{@language.downcase}"]["amp_url"] %{file_name: @file_name}
        end
      end
      {:title =>meta_title,:keywords=>meta_keywords,:description=>meta_description,amp_url: amp_url}
    end

  def og_tags
    lang_countries = ["en-IN","hi-IN","ar-AE","en-AE","ar-SA","en-SA","ar-BH","en-BH","ar-KW","en-KW","ar-OM","en-OM","ar-QA","en-QA"]
    main_content = "#{@language.downcase}-#{@country_code}"
    alts = []
    lang_countries.each do |l|
      unless main_content === l
        alts << l
      end
    end
      {main_content: main_content, alts: alts}
  end
  
  def custom_pagination(page_no,routes,file_name)
    prev_no = next_no = 0
    routes_count = routes.count 
    pagination_routes_count = routes_count-44
    total_pages,remaing_routes_count = pagination_routes_count.divmod(45)
    file_name = file_name.gsub(/\d/,'').gsub(".html",'')

    if remaing_routes_count > 0   
      total_pages += 1
    end
    start_index = 46*page_no
    end_index = start_index + 44
    if page_no == 0
      next_no = page_no + 1
      prev_url = "#{file_name}.html"
      next_url = "#{file_name}-#{next_no}.html"
      routes = routes[start_index..end_index]
    elsif page_no == 1
      next_no = page_no + 1
      prev_url = "#{file_name}.html"
      next_url = "#{file_name}-#{next_no}.html"
      routes = routes[start_index..end_index]
    else
      prev_no = page_no - 1
      next_no = page_no + 1
      prev_url = "#{file_name}-#{prev_no}.html"
      next_url  = "#{file_name}-#{next_no}.html"
      routes = routes[start_index..end_index]
    end
    return {routes: routes,current_page_no: page_no,prev_url: prev_url,next_url: next_url,prev_no: prev_no,next_no: next_no,total_pages: total_pages}
  end
  
  def get_domain
    protocol = request.protocol
    unless protocol.include? "s"
        protocol = "https://"
    end
    hostname = request.host
    "#{protocol}#{hostname}"
  end

    def to_time(timeObj)
      begin 
        timeObj.strftime("%H:%M %p")
      rescue 
        ""
      end
    end
    
  def check_domain(language,country_code)
    country_codes = ["AE","SA","BH","QA","KW","OM"]
    if language=="ar" && country_code=="IN"
      return true
    elsif language=="hi" && country_codes.include?(country_code)
      if country_code=="AE" || country_code=="SA"
        return true
      else
        return true
      end
    else
      return false
    end
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

  def format_overview_link(carrier_name, locale = nil)
  	unless carrier_name.blank?
     if(carrier_name.downcase.include?('airlines') || carrier_name.downcase.include?('airline')|| carrier_name.downcase.include?('air lines'))
       result = carrier_name.downcase
       result = result.gsub("airlines","")
       result = result.gsub("airline","")
       result = result.gsub("air lines","")
       result = result.strip.downcase.gsub(" ", "-")
       result = result+"-airlines"
     else
       result = carrier_name.downcase.gsub(" ","-")+ "-airlines"
     end
   end
 end

 def format_baggage_link(carrier_name)
  unless carrier_name.blank?
    if(carrier_name.downcase.include?('airlines') || carrier_name.downcase.include?('airline')|| carrier_name.downcase.include?('air lines'))
      result = carrier_name.downcase
      result = result.gsub("airlines","")
      result = result.gsub("airline","")
      result = result.gsub("air lines","")
      result = result.strip.downcase.gsub(" ", "-")
      result = result+"-baggages"
    else
      result = carrier_name.downcase.gsub(" ","-")+ "-baggages"
    end
  end
end

  # def translate_airport(code)
  #   begin
  #     unless code.blank?
  #       I18n.with_locale(:en) { t("airlines.PPgdf") }
  #     end
  #   rescue => error
  #     puts error
  #     return ''
  #   end
  # end

  def format_airline_name(carrier_name, locale = nil)
    unless carrier_name.blank?
      result = carrier_name
      if(carrier_name.include?('Airlines') || carrier_name.include?('Airline')|| carrier_name.include?('Air line') || carrier_name.include?('Air Lines') || carrier_name.include?('airline'))
        result = result.gsub("Airlines","")
        result = result.gsub("Airline","")
        result = result.gsub("Air lines","")
        result = result.gsub("Air Lines","")
        result = result.gsub("airline", "")

        if locale == :hi
          result = result+" एयरलाइंस "
        elsif locale == :ar
          result = result+" الخطوط الجوية "
        else
          result = result +" Airlines"
        end

      else
        result = carrier_name + " Airlines"
      end
      if locale == :hi
        if(result.include?('एयरलाइंस') || result.include?('एयरलाइन')|| result.include?('एयर लाइन') || result.include?('एयर लाइन्स')) || result.include?('Airlines')
          result = result.gsub("एयरलाइंस","")
          result = result.gsub("एयरलाइन","")
          result = result.gsub("एयर लाइन","")
          result = result.gsub("एयर लाइन्स","")
          result = result.gsub("Airlines","")
          result = result+" एयरलाइंस "
        else
          result = result + " एयरलाइंस "
        end
      end
      if locale == :ar
        if(result.include?('الخطوط الجوية') || result.include?('الطيران')|| result.include?('خط جوي') || result.include?('الخطوط الجوية')) || result.include?('Airlines')

          result = result.gsub("الخطوط الجوية","")
          result = result.gsub("الخط الجوي","")
          result = result.gsub("خط جوي","")
          result = result.gsub("الخطوط الجوية","")
          result = result.gsub("Airlines","")
          result = result + " الخطوط الجوية "
        else
          result = result + " الخطوط الجوية "
        end
      end
    end
    return result

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

  
  def display_host(country_code)
    # puts "country_code - #{country_code}"
    if country_code == 'AE'
      return 'Cleartrip.ae'
    elsif country_code == 'KW'
      return 'kw.cleartrip.com'
    elsif country_code == 'SA'
      return 'Cleartrip.sa'
    elsif country_code == 'BH'
      return 'bh.cleartrip.com'
    elsif country_code == 'QA'
      return 'qa.cleartrip.com'
    elsif country_code == 'OM'
      return 'om.cleartrip.com'
    elsif country_code == 'IN'
      return 'Cleartrip.com'
    else
      ''
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

  def retrieve_days(days)
     if !days.nil?
       if days.delete(" ").length == 7
         return I18n.t("daily")
       else
        day_names = I18n.t('date.abbr_day_names')
        days = days.delete(" ")
        str = ""
        i = 1
        days.each_char  do |day|
          if (i == 1)
            if ((day.to_i) == 7)
              str  = (day_names[0])
            else
              str  = (day_names[(day.to_i)])
            end
          else
            if ((day.to_i) == 7)
              str  = str + ", " + (day_names[0])
            else
              str  = str + ", " + (day_names[(day.to_i)])
            end
          end
          i = i  + 1
        end
        return str
      end
    end
  end
end
