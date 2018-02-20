module ApplicationHelper
  def convert_time(duration)
    
  end
  def to_time(timeObj)
    begin 
      timeObj.strftime("%H:%M %p")
    rescue 
      ""
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
end
