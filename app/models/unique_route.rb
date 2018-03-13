class UniqueRoute < ApplicationRecord
	has_many :collectives
	has_many :flight_schedule_collectives
	has_many :airline_brand_collectives
end
