class AddColumnsToUniqueRoute < ActiveRecord::Migration[5.1]
  def change
    add_column :unique_routes, :schedule_route_url, :string
    add_column :unique_routes, :ticket_route_url, :string
  end
end
