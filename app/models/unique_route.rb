class UniqueRoute < ApplicationRecord
	has_many :collectives
	has_many :flight_schedule_collectives
end
