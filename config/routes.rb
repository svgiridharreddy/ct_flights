class DynamicValue
end
Rails.application.routes.draw do
	resources :flights
	
	scope 'flight-schedule' do 
		get '/:route' => "flight_schedules#schedule_values"
		get '/:dep_city_name-:arr_city_name-flights.html' => "flight_schedules#schedule_values"
		get '/:lang/:dep_city_name-:arr_city_name-flights.html' => "flight_schedules#schedule_values"
	end	
	scope ':lang/flight-schedule' do
		get '/:dep_city_name-:arr_city_name-flights.html' => "flight_schedules#schedule_values"
	end
	scope 'flight-booking' do 
		get '/' => "flight_bookings#booking_values"
	end
	
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
