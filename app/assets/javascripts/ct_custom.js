$(document).ready(function() {
  var isMobile = {
    Android: function() {
      return navigator.userAgent.match(/Android/i);
    },
    BlackBerry: function() {
      return navigator.userAgent.match(/BlackBerry/i);
    },
    iOS: function() {
      return navigator.userAgent.match(/iPhone|iPad|iPod/i);
    },
    Opera: function() {
      return navigator.userAgent.match(/Opera Mini/i);
    },
    Windows: function() {
      return navigator.userAgent.match(/IEMobile/i);
    },
    any: function() {
      return (isMobile.Android() || isMobile.BlackBerry() || isMobile.iOS() || isMobile.Opera() || isMobile.Windows());
    }
  };

  var ignore_internationals = ["www.cleartrip.sa"]
  var mobile_link = (isMobile.any()) ? "/m" : ""
  var from_country;
  var to_country;

  if(typeof(lang)=="undefined"){
    lang = {
      "calender": {
        "airfare": "Airfare Calendar",
        "today": "Today",
        "cheapest": "Cheapest",
        "calendar_note": "Note: Cleartrip Lowest Air Fares Calendar provides an indication of prices (per person) for a range of dates, so that you can see the cheapest air fares easily. The air fares you see here may not be available at the time you try and book."
      },
      "flight_schedule": {
        "mo": "Mo",
        "tu": "Tu",
        "we": "We",
        "th": "Th",
        "fr": "Fr",
        "sa": "Sa",
        "su": "Su"
      },
      "currency": "Rs.",
      "month": ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
    };
  }

  lang.currency = location.hostname == "www.cleartrip.com" ? "Rs." :"AED"
  if(typeof(lang["month"])=="undefined"){
    lang["month"] = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
  }

  if(isMobile.any()==null){
    $("#fullCalendarShow").hide();
    $("#horCalendar").hide()
    $("#calendar").show()
  }else{
    $("#calendar").hide()
  }
  var dep_code = $('#departure_city_code').text();
  var arr_code = $('#arrival_city_code').text();
  var carrier_code = $('#carrier_code').text();
  switch(typeof(country_code)){
    case "undefined":
    section = "IN"
    break;
    case "object":
    section = $(country_code).text();
    break;
    case "string":
    section = (country_code.toLowerCase()=="in")? "IN" : "AE"
    break;
  }
  if($("#calendar").length>0)
  {
    var url = "https://www.cleartrip.com/seoapi/flight_api/calendar?from=" + dep_code + "&to=" + arr_code+"&section="+section;
    $.ajax({
      type: "GET",
      dataType: 'json',
      url: url
    }).done(function(data) {
      var flight_calendar = data['calendar_json'];
      var currency = data['sell_currency_json']["symbol"]
      if (flight_calendar != null) {
        var prices = [];
        var calendar_values = [];
        var cheapest_ticket = 0;
        var costlist_ticket = 0;
        var cheap_flight=null;
        var cheap_ticket=null;
        var cheap_airline=null;
         var avaiable_values =[]
        $.each(flight_calendar, function(key, val) {
          for (var i = 0; i < val.length; i++) {
            if (val[i]['pr'] != null) {
              prices.push(parseFloat(val[0]['pr']));
               a =key.replace(/(\d{4})\-?(\d{2})\-?(\d{2})/,'$1-$2-$3')
              key_date = new Date(a)
              current_date = new Date()
              month = current_date.getMonth()+1
              month = month >= 10 ? month : "0"+month
              current_day = current_date.getDate() <= 9 ?"0"+current_date.getDate(): current_date.getDate()
              b=current_date.getFullYear()+"-"+month+"-"+current_day
              if(a>=b){
                avaiable_values.push(parseFloat(val[0]['pr']));
              }
            }
          }
          if (val.length > 0) {
            calendar_values.push(val);
          }
        });
        //sort prices
        prices.sort(function(a, b) {
          return a - b;
        });;
        //console.log(prices);
        // # Get all values which are required by the Page
        if (prices != null) {
          cheapest_ticket = prices[0];
          costlist_ticket = prices[prices.length - 1];
        }
        // # Get all values count present in the dates of calendar
        var calendar_routes = calendar_values.length
          //creating calendar object to be placed in a div
          if(avaiable_values.length >3){
          if (calendar_routes >= 3) {
            $('#link-to-calendar').append('<a href="#calendref">' + lang.calender.airfare + '</a>');
            if ($('a[href=#calendref]').length > 1) $('a[href=#calendref]').first().remove()
              var day_count = 1
            var now = new Date();
          //console.log(now);
          var today = new Date();
          var calendar_start = new Date(today.setDate(today.getDate() - today.getDay()));
          // var firstday = addDays(new Date(now.setDate(now.getDate() - now.getDay())), 1);
          //console.log(firstday);
          //display calendar
          //add content to calendar div
          var calendar_container = $('<table class="calendar table-bordered" id="calendar_table" width="100%" > <colgroup class="weekday"> <col class="Mon" /> <col class="Tue" /> <col class="Wed" /> <col class="Thu" /> <col class="Fri" /> </colgroup> <colgroup class="weekend"> <col class="Sat" /> <col class="Sun" /> </colgroup> <thead> <tr> <th>' + lang.flight_schedule.mo + '</th><th>' + lang.flight_schedule.tu + '</th> <th>' + lang.flight_schedule.we + ' </th> <th>' + lang.flight_schedule.th + ' </th> <th>' + lang.flight_schedule.fr + '</th> <th>' + lang.flight_schedule.sa + ' </th> <th>' + lang.flight_schedule.su + '</th> </tr> </thead><tbody>');
          $('#calender_display').append(calendar_container);
          $('#calender_display table tbody').append('<tr class="day">');
          if ($('#calender_display .calendar').length > 1) {
            $($('.calendar')[0]).next().remove()
            $($('.calendar')[0]).remove()
          };
          $("#slider").empty()
          for (var i = 1; i <= 35; i++) {
            var cal_day = addDays(calendar_start, day_count);
            if ((cal_day > now) && (cal_day != now)) {
              var cheap_flight = get_cheap_flight(flight_calendar, cal_day);
            }
            if (cheap_flight != null) {
              cheap_ticket = cheap_flight.pr;
              cheap_airline = cheap_flight.aln;
              cheap_airline_code = cheap_flight.al;
            }
            if (!(cal_day.isSameDateAs(now)) && (cheapest_ticket != cheap_ticket)) {
              $('#calender_display table tbody tr:last').append('<td id="day_' + i + '">');
            } else {
              if (cal_day.isSameDateAs(now)) {
                $('#calender_display table tbody tr:last').append('<td id="day_' + i + '" class="today">')
              }
              if (cheapest_ticket == cheap_ticket) {
                $('#calender_display table tbody tr:last').append('<td id="day_' + i + '" class=best>')
              }
            }
            if (cal_day.isSameDateAs(now)) {
              $('#calender_display table tbody tr:last td:last').append('<p><span> ' + lang.calender.today + '  </span>' + addZero(cal_day.getDate()) + ' ' + lang.month[cal_day.getMonth()] + '</p>');
            } else if (cheapest_ticket == cheap_ticket) {
              $('#calender_display table tbody tr:last td:last').append('<p><span class="mobile">' + lang.calender.cheapest + ' </span>' + addZero(cal_day.getDate()) + ' ' + lang.month[cal_day.getMonth()] + '</p>');
            } else {
              $('#calender_display table tbody tr:last td:last').append('<p>' + addZero(cal_day.getDate()) + ' ' + lang.month[cal_day.getMonth()] + '</p>');
            }
            if ((cal_day > now) && !(cal_day.isSameDateAs(now))) {
              if (cheap_ticket != null) {
                $('#calender_display table tbody tr:last td:last').append('<div class="vevent"> <abbr class="dtstart" title="' + cal_day.toJSON().substring(8, 10) + '/' + cal_day.toJSON().substring(5, 7) + '/' + cal_day.toJSON().substring(0, 4) + '"></abbr>');
              } else {
                $('#calender_display table tbody tr:last td:last')
              }
              if (cheap_ticket != null) {
                var cheap_ticket_val = Math.round(parseFloat(cheap_ticket));
                cheap_ticket_val = cheap_ticket_val.toFixed(2).replace(/(\d)(?=(\d{3})+\.)/g, '$1,').split('.')[0];
                $('#calender_display  table tbody tr:last td:last div').append('<p class="summary"><a id="anchorDate_' + day_count + '" href="/flights/results?from=' + dep_code + '&to=' + arr_code + '&adults=1&childs=0&infants=0&depart_date=' + cal_day.toJSON().substring(8, 10) + '/' + cal_day.toJSON().substring(5, 7) + '/' + cal_day.toJSON().substring(0, 4) + '&dep_time=0&class=Economy&airline='+cheap_airline_code+'&carrier=&x=57&y=16&flexi_search=no" title="Click for flight details and booking"  rel="nofollow">' + lang.currency + ' ' + cheap_ticket_val + '</a></p><dl class="description"><dt><span title="Going there" class="to"></span></dt><dd>' + cheap_airline + '</dd></dl>');
                link = '/flights/results?from=' + dep_code + '&to=' + arr_code + '&adults=1&childs=0&infants=0&depart_date=' + cal_day.toJSON().substring(8, 10) + '/' + cal_day.toJSON().substring(5, 7) + '/' + cal_day.toJSON().substring(0, 4) + '&dep_time=0&class=Economy&airline='+cheap_airline_code+'&carrier=&x=57&y=16&flexi_search=no'
                $('#calender_display').append('</div>');
                cal_html = '<div class="slide"><a href="'+link+'"><span class="date-info">'+cal_day.format("ddd, dd mmm")+'</span><span class="price-info"><span class="currency-symboal"></span><span class="currency-symboal">'+lang.currency+'</span>'+cheap_ticket_val+'</span></a></div>'
              } else {
                cal_html=""
                $('#calender_display table tbody tr:last td:last div').append('<p></p>');
              }
              $("#slider").append(cal_html)
            }
            
            $('#calender_display table tbody tr').append('</td>');
            //display for 7 days
            if (i % 7 == 0) {
              //only add new tr if loop has not reached end
              if (i == 35) {
                $('#calender_display table tbody').append('</tr>');
              } else {
                $('#calender_display table tbody').append('</tr><tr>');
              }
            }
          }
          slider.reloadSlider()
          //Note to be displayed at the end
          $('#calender_display').append('<span style="color:#888888; font-size:11px">' + lang.calender.calendar_note + '</span>');
        } else {
          $('#calendar').hide();
        }
      }else{
        $('.calendar-new').hide()
      }
      }
    }).fail(function(xhr, textStatus, errorThrown) {

    });
  }

  function addDays(dateObj, numDays) {
    dateObj.setDate(dateObj.getDate() + numDays);
    return dateObj;
  }

  function subDays(dateObj, numDays) {
    dateObj.setDate(dateObj.getDate() - numDays);
    return dateObj;
  }

  function addZero(i) {
    if (i < 10) {
      i = "0" + i;
    }
    return i;
  }

  function get_cheap_flight(flight_calendar, cal_day) {
    var cheap_flight;
    var cheap_day_price = [];
    var day = addZero(cal_day.getDate());
    var month = addZero(cal_day.getMonth() + 1);
    var year = cal_day.getFullYear();
    var cheapest_ticket;
    full_date = year.toString() + month.toString() + day.toString();
    intDate = parseInt(full_date);
    day_data = flight_calendar[intDate];
    if (day_data != null) {
      $.each(day_data, function(key, val) {
        if (carrier_code!='') {
          if (val.al==carrier_code) {
            $.each(val, function(ckey, cval) {
              if (cval != null && ckey == 'pr') {
                cheap_day_price.push(parseFloat(cval));
              }
            });
          };
        } else {
          $.each(val, function(ckey, cval) {
            if (cval != null && ckey == 'pr') {
              cheap_day_price.push(parseFloat(cval));
            }
          });
        }
      });
      cheapest_ticket = cheap_day_price.sort(function(a, b) {
        return a - b;
      })[0];
      $.each(day_data, function(key, val) {
        if (carrier_code!='') {
          if (val.al==carrier_code) {
            $.each(val, function(ckey, cval) {
              if (ckey == 'pr') {
                if (cval != null && cval == cheapest_ticket) {
                  cheap_flight = val;
                }
              }
            });
          }
        } else {
          $.each(val, function(ckey, cval) {
            if (ckey == 'pr') {
              if (cval != null && cval == cheapest_ticket) {
                cheap_flight = val;
              }
            }
          });
        }
      });
    }
    return cheap_flight;
  }
  Date.prototype.isSameDateAs = function(pDate) {
    return (this.getFullYear() === pDate.getFullYear() && this.getMonth() === pDate.getMonth() && this.getDate() === pDate.getDate());
  }
  $("#show_all_flights").click(function() {
    $("#airline-lists li.showMore").toggleClass("hide")
  })
  $(".mview-list li.showMore").addClass("hide")
  $("#show_all_flights_mobile").click(function() {
    $(".mview-list li.showMore").toggleClass("hide")
  })
  $("#fullCalendarShow").click(function() {
    $("#calendar").slideToggle();
    $("#horCalendar").slideToggle();
  })
  var slider = $('#slider').bxSlider({
    slideWidth: 110,
    minSlides: 2,
    maxSlides: 7,
    slideMargin: 0,
    infiniteLoop:false,
    hideControlOnEnd:true
  });
  if ($('#back-to-top').length) {
    var scrollTrigger = 100, // px
    backToTop = function() {
      var scrollTop = $(window).scrollTop();
      if (scrollTop > scrollTrigger) {
        $('#back-to-top').addClass('show');
      } else {
        $('#back-to-top').removeClass('show');
      }
    };
    backToTop();
    $(window).on('scroll', function() {
      backToTop();
    });
    $('#back-to-top').on('click', function(e) {
      e.preventDefault();
      $('html,body').animate({
        scrollTop: 0
      }, 700);
    });
  }

  var no_months = isMobile.any() ? 1 : 2;
  $("#dpt_date,#rtn_date").datepicker({
    firstDay: 1,
    minDate:0,
    dateFormat: "dd/mm/yy",
    numberOfMonths: no_months,
    dayNamesMin: ["S", "M", "T", "W", "T", "F", "S"],
    onSelect: function() {
      var minDate = $('#dpt_date').datepicker('getDate');
      $("#rtn_date").datepicker("change", { minDate: minDate });
      var maxDate = $('#rtn_date').datepicker('getDate');
      $("#dpt_date").datepicker("change", { maxDate: maxDate });
    }
  })
  $("input[name='rnd_one']").change(function(){
    if($(this).val()=="R"){
      $('#returnDateSec').fadeIn()
    }else{
      $('#returnDateSec').fadeOut()
    }
  })
  $("#origin_autocomplete,#destination_autocomplete").autocomplete({
    source:function(req,resp){
      $.getJSON("https://www.cleartrip.com/places/airports/search?string="+req.term,function(res){
        var result_data = []
        $.each(res,function(i,d){
          result_data.push({"label":d.v,"value":d.v})
        })
        resp(result_data);
      })
    },
    select:function(ui,selected){
      var selected_city = extractCITY(selected.item.value)
      if(ui.target.id=="origin_autocomplete"){
        from_country = extractCountry(selected.item.value)
        $("#from").val(selected_city)
      }else{
        to_country = extractCountry(selected.item.value)
        $("#to").val(selected_city)
      }

    },
    minLength:3
  })

  if (dep_code!=undefined && dep_code!=null && dep_code!='') {
    $.ajax({
      type: "GET",
      dataType: 'json',
      url: "https://www.cleartrip.com/places/airports/search?string="+dep_code
    }).done(function(dep_data) {
      if (dep_data[0]!=undefined){
        $("#from").val(dep_code)
        $.each(dep_data, function(index){
          if (dep_code==dep_data[index].k) {
            from_country = extractCountry(dep_data[index].v)
            $("#origin_autocomplete").val(dep_data[index].v)
          }
        })
      }
    })
  };
  if (arr_code!=undefined && arr_code!=null && arr_code!='') {
    $.ajax({
      type: "GET",
      dataType: 'json',
      url: "https://www.cleartrip.com/places/airports/search?string="+arr_code
    }).done(function(arr_data) {
      if (arr_data[0]!=undefined){
        $("#to").val(arr_code)
        $.each(arr_data, function(index){
          if (arr_code==arr_data[index].k) {
            to_country = extractCountry(arr_data[index].v)
            $("#destination_autocomplete").val(arr_data[index].v)
          }
        })
      }
    })
  }
  var arDomains = ["www.cleartrip.sa","www.cleartrip.ae"];
  if (typeof window.languageType != "undefined" ) {
    var languageType = window.languageType;
  }
  if (typeof window.language_type != "undefined") {
    var languageType = window.language_type;
  }
  
  var two_days = Date.now()+(24*2*60*60*1000)
  var diff_days = Date.now()+(24*4*60*60*1000)
  
  $("#dpt_date").val(new Date(two_days).format("dd/mm/yyyy"))
  $("#rtn_date").val(new Date(diff_days).format("dd/mm/yyyy"))
  $("#button_flight_search").click(function(){
    var inp_val = $("input[name='rnd_one']:checked").val()
    if(inp_val=="O"){
      ret_val = $("#rtn_date").val()
      $("#rtn_date").val("")
    }
    this.form.target="_self"
    var international_link = (from_country.toLowerCase()!=country_code || to_country.toLowerCase() !=country_code)? "international/" : "";
    if(isMobile.any()){
      domains = [ "www.cleartrip.com"];
      // sections = [ "domestic","international" ];
      if (location.hostname != (domains.indexOf(location.hostname)>=0)){
        if (from_country.toLowerCase() =='in' && to_country.toLowerCase() =='in'){
          var international_link ="";
        } else {
          var international_link =  "international/";
        }

      } else {
        var international_link = "international/";
      }
      if (typeof international_link == "undefined"){
        var international_link =  "international/";
      }
     $(this).closest("form").append("<input type='hidden' name='mobile' value='true'>");
       if (languageType == "ar" &&  $.inArray(location.hostname,arDomains) >= 0 ) {
          this.form.action = "/ar/m/flights/"+international_link+"results"
        } 
        else{
          this.form.action = "/m/flights/"+international_link+"results"
        }
   }else{
      if (languageType == "ar" &&  $.inArray(location.hostname,arDomains) >=0 ) {
        this.form.action = "/ar/flights/"+international_link+"search"
      }
      else {
      this.form.action = "/flights/"+international_link+"search"
      }
  }
  this.form.submit();
})

  $(".flight-schedule-booking").each(function(){
    var cur_date = new Date().format("dd/mm/yyyy")
    var routes =  $(this).data("route").split("-")
    two_date = new Date(two_days).format("dd/mm/yyyy")
    var data_section = $(this).data("section")
    if(typeof data_section =="undefined"){
      data_section = routes[3];
    } 
    if(data_section=="int")
      if (languageType == "ar" &&  $.inArray(location.hostname,arDomains) >=0 ) {
        var link =  location.protocol+"//"+location.hostname+mobile_link+"/ar/flights/international/results?from="+routes[0]+"&to="+routes[1]+"&depart_date="+two_date+"&adults=1&childs=0&infants=0&page=loaded";
      } else {
        var link =  location.protocol+"//"+location.hostname+mobile_link+"/flights/international/results?from="+routes[0]+"&to="+routes[1]+"&depart_date="+two_date+"&adults=1&childs=0&infants=0&page=loaded";
      }
    else 
      if (languageType == "ar" &&  $.inArray(location.hostname,arDomains) >=0 ) {
        var link =  location.protocol+"//"+location.hostname+mobile_link+"/ar/flights/results?from="+routes[0]+"&to="+routes[1]+"&depart_date="+two_date+"&adults=1&childs=0&infants=0&page=loaded";
      } else {
        var link =  location.protocol+"//"+location.hostname+mobile_link+"/flights/results?from="+routes[0]+"&to="+routes[1]+"&depart_date="+two_date+"&adults=1&childs=0&infants=0&page=loaded";
      }
    if (routes[2]!=undefined && mobile_link=="") {
      link+= "&airline="+routes[2]
    };
    $(this).attr("href",link)
  })
  $("#adults").change(function(){
    selected = parseInt($(this).val())
    $("#children").empty()
    for(i=0;i<=(9-selected);i++){
      $("#children").append($("<option>").val(i).html(i))
    }
    $("#children").change()
  })
  $("#children").change(function(){
    $("#infants").empty()
    child_selected = parseInt($("#children").val())
    for(i=0;i<=(9-child_selected);i++){
      $("#infants").append($("<option>").val(i).html(i))
    }
  })
  if(typeof(section_type)!="undefined" && section_type=="international"){
    var action = $("#AirSearch").attr("action")
    if(action=="/flights/search"){
      if(isMobile.any()){
       link = mobile_link+"/flights/international/results";
     } else {
       link = mobile_link+"/flights/international/search";
     }
     $("#AirSearch").attr('action',link);
   }
 }
 load_calendars = ["www.cleartrip.com","www.cleartrip.ae"]
 curr_domain = location.hostname
 if(load_calendars.indexOf(curr_domain)<0){
  $(".calendar-new").hide();
}
});
function extractCITY(str){
  var regex = /.*\(([A-Z]*)\)$/;
  if(str){
    return str.match(regex)[1]
  }
}
function extractCountry(str){
  var regex = /.+, ([A-Z]{2}) - .+/;
  if(str){
    return str.match(regex)[1]
  }
}