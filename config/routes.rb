class DynamicValue
end
Rails.application.routes.draw do
	resources :flights
	
	scope 'flight-schedule' do 
		get '/:route' => "flight_schedules#schedule_values"
	end	
	scope ':lang/flight-schedule' do
		get '/:route' => "flight_schedules#schedule_values"
	end
	scope 'flight-booking' do 
		get '/:airline' => "overview_bookings#booking_values"
	end
	scope ':lang/flight-booking' do 
		get '/:airline' => "overview_bookings#booking_values"
	end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
