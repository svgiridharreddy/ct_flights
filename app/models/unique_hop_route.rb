class UniqueHopRoute < ApplicationRecord
	has_many :in_flight_hop_schedule_collectives,dependent: :nullify
end
