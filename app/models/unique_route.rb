class UniqueRoute < ApplicationRecord
	has_many :collectives
	has_many :ae_flight_schedule_collectives
	has_many :in_flight_schedule_collectives
	has_many :sa_flight_schedule_collectives
	has_many :bh_flight_schedule_collectives
	has_many :om_flight_schedule_collectives
	has_many :kw_flight_schedule_collectives
	has_many :qa_flight_schedule_collectives
	has_many :airline_brand_collectives
end


