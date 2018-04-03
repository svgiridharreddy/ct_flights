# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180403063126) do

  create_table "ae_airline_contents", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "carrier_code"
    t.string "carrier_name"
    t.string "country_code"
    t.string "icoa_code"
    t.string "meta_title_en"
    t.string "meta_title_ar"
    t.string "meta_description_en"
    t.string "meta_description_ar"
    t.text "overview_content_en", limit: 4294967295
    t.text "overview_content_ar", limit: 4294967295
    t.text "baggage_content_en", limit: 4294967295
    t.text "baggage_content_ar", limit: 4294967295
    t.text "cancellation_content_en", limit: 4294967295
    t.text "cancellation_content_ar", limit: 4294967295
    t.text "customer_support_content_en", limit: 4294967295
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ae_flight_schedule_collectives", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "carrier_code"
    t.integer "flight_no"
    t.string "dep_time"
    t.string "arr_time"
    t.string "duration"
    t.string "days_of_operation"
    t.string "dep_city_code"
    t.string "arr_city_code"
    t.string "dep_country_code"
    t.string "arr_country_code"
    t.bigint "unique_route_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["unique_route_id"], name: "index_ae_flight_schedule_collectives_on_unique_route_id"
  end

  create_table "airline_brand_collectives", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "carrier_code"
    t.string "carrier_name"
    t.string "flight_no"
    t.string "dep_time"
    t.string "arr_time"
    t.string "duration"
    t.string "days_of_operation"
    t.string "dep_city_code"
    t.string "arr_city_code"
    t.string "dep_country_code"
    t.string "arr_country_code"
    t.bigint "unique_route_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["carrier_code", "carrier_name"], name: "indecies"
    t.index ["unique_route_id"], name: "index_airline_brand_collectives_on_unique_route_id"
  end

  create_table "airline_brands", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "carrier_code"
    t.string "carrier_name"
    t.string "icoa_code"
    t.string "base_airport"
    t.string "country"
    t.integer "brand_routes_count"
    t.string "country_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "publish_status"
    t.string "carrier_name_ar"
    t.string "carrier_name_hi"
  end

  create_table "airline_contents", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "carrier_code"
    t.string "carrier_name"
    t.string "country_code"
    t.text "content_en_in"
    t.text "content_en_ae"
    t.text "content_en_sa"
    t.text "content_en_bh"
    t.text "content_en_kw"
    t.text "content_en_qa"
    t.text "content_en_om"
    t.text "content_hi_in"
    t.text "content_ar_ae"
    t.text "content_ar_sa"
    t.text "content_ar_bh"
    t.text "content_ar_kw"
    t.text "content_ar_qa"
    t.text "content_ar_om"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "icoa_code"
  end

  create_table "airports", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "id"
    t.timestamp "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.timestamp "updated_at", null: false
    t.string "airport_code"
    t.string "airport_name"
    t.string "city_code"
    t.string "city_name"
    t.string "country_code"
    t.string "country_name"
    t.string "address"
    t.string "phone"
    t.string "email"
    t.string "website"
    t.string "latitude"
    t.string "longitude"
    t.string "airport_type"
    t.string "wikipedia_link"
    t.string "year_of_establishment"
    t.integer "seq_order"
    t.boolean "is_published"
    t.integer "airport_routes_count"
    t.text "index_content"
    t.boolean "is_index"
    t.float "arr_latitude", limit: 53
    t.float "arr_langitude", limit: 53
  end

  create_table "bh_airline_contents", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "carrier_code"
    t.string "carrier_name"
    t.string "country_code"
    t.string "icoa_code"
    t.string "meta_tile_en"
    t.string "meta_title_ar"
    t.string "meta_description_en"
    t.string "meta_description_ar"
    t.text "overview_content_en", limit: 4294967295
    t.text "overview_content_ar", limit: 4294967295
    t.text "baggage_content_en", limit: 4294967295
    t.text "baggage_content_ar", limit: 4294967295
    t.text "cancellation_content_en", limit: 4294967295
    t.text "cancellation_content_ar", limit: 4294967295
    t.text "customer_support_content_en", limit: 4294967295
    t.text "customer_support_content_ar", limit: 4294967295
    t.text "pnr_content_en", limit: 4294967295
    t.text "pnr_content_ar", limit: 4294967295
    t.text "web_checkin_content_en", limit: 4294967295
    t.text "web_checkin_content_ar", limit: 4294967295
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "bh_flight_schedule_collectives", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "carrier_code"
    t.integer "flight_no"
    t.string "dep_time"
    t.string "arr_time"
    t.string "duration"
    t.string "days_of_operation"
    t.string "dep_city_code"
    t.string "arr_city_code"
    t.string "dep_country_code"
    t.string "arr_country_code"
    t.bigint "unique_route_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["unique_route_id"], name: "index_bh_flight_schedule_collectives_on_unique_route_id"
  end

  create_table "city_contents", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "city_code"
    t.string "city_name_en"
    t.string "city_name_ar"
    t.string "city_name_hi"
    t.text "content_in_en"
    t.text "content_ae_en"
    t.text "content_sa_en"
    t.text "content_bh_en"
    t.text "content_kw_en"
    t.text "content_qa_en"
    t.text "content_om_en"
    t.text "content_in_hi"
    t.text "content_ae_ar"
    t.text "content_sa_ar"
    t.text "content_bh_ar"
    t.text "content_kw_ar"
    t.text "content_qa_ar"
    t.text "content_om_ar"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "city_names", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "city_code"
    t.string "city_name_en"
    t.string "city_name_ar"
    t.string "city_name_hi"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "collectives", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "operational_airlines"
    t.string "airline_flight_count"
    t.bigint "unique_route_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["unique_route_id"], name: "index_collectives_on_unique_route_id"
  end

  create_table "fare_calendars", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string "source_city_code"
    t.string "destination_city_code"
    t.text "calendar_json", limit: 4294967295
    t.string "section"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "flight_schedules", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "connection_id"
    t.string "carrier_code"
    t.string "flight_no"
    t.string "dep_airport_code"
    t.string "dep_city_code"
    t.string "dep_country_code"
    t.string "arr_airport_code"
    t.string "arr_city_code"
    t.string "arr_country_code"
    t.string "dep_time"
    t.string "arr_time"
    t.integer "arrival_day_marker"
    t.string "elapsed_journey_time"
    t.integer "flight_count"
    t.date "effective_from"
    t.date "effective_to"
    t.string "day_of_operation"
    t.integer "stop"
    t.string "intermediate_airports"
    t.string "data_source"
    t.integer "distance"
    t.date "created_at"
  end

  create_table "flights_headers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "dep_city_code"
    t.string "arr_city_code"
    t.string "dep_city_name"
    t.string "arr_city_name"
    t.string "hop"
    t.string "page_type"
    t.string "route_type"
    t.string "language"
    t.text "hotel_details", limit: 4294967295
    t.text "train_details", limit: 4294967295
    t.text "tourism_details", limit: 4294967295
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status"
  end

  create_table "footers", id: :integer, default: nil, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "city_code"
    t.string "city_name"
    t.string "country_code"
    t.string "country_name"
    t.integer "total_routes_count"
    t.text "routes_data"
    t.integer "current_routes_count"
    t.string "city_name_ar"
    t.text "routes_data_ar"
  end

  create_table "headers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "dep_city_code"
    t.string "arr_city_code"
    t.string "dep_city_name"
    t.string "arr_city_name"
    t.string "route_type"
    t.string "dep_city_event"
    t.string "dep_city_weekend_getaway"
    t.string "dep_city_package"
    t.string "dep_city_featured"
    t.string "dep_city_things_todo"
    t.text "hotel_details", limit: 4294967295
    t.text "train_details", limit: 4294967295
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "arr_city_event"
    t.string "arr_city_weekend_getaway"
    t.string "arr_city_package"
    t.string "arr_city_featured"
    t.string "arr_things_todo"
  end

  create_table "in_airline_contents", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "carrier_code"
    t.string "carrier_name"
    t.string "country_code"
    t.string "icoa_code"
    t.string "meta_title_en"
    t.string "meta_title_hi"
    t.text "meta_description_en"
    t.text "meta_description_hi"
    t.text "overview_content_en", limit: 4294967295
    t.text "overview_content_hi", limit: 4294967295
    t.text "baggage_content_en", limit: 4294967295
    t.text "baggage_content_hi", limit: 4294967295
    t.text "cancellation_content_en", limit: 4294967295
    t.text "cancellation_content_hi", limit: 4294967295
    t.text "customer_support_content_en", limit: 4294967295
    t.text "customer_support_content_hi", limit: 4294967295
    t.text "pnr_content_en", limit: 4294967295
    t.text "pnr_content_hi", limit: 4294967295
    t.text "web_checkin_content_en", limit: 4294967295
    t.text "web_checkin_content_hi", limit: 4294967295
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "in_flight_schedule_collectives", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string "carrier_code"
    t.integer "flight_no"
    t.string "dep_time"
    t.string "arr_time"
    t.string "duration"
    t.string "days_of_operation"
    t.string "dep_city_code"
    t.string "arr_city_code"
    t.string "dep_country_code"
    t.string "arr_country_code"
    t.bigint "unique_route_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["unique_route_id"], name: "index_in_flight_schedule_collectives_on_unique_route_id"
  end

  create_table "in_footers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string "city_code"
    t.string "city_name"
    t.string "city_name_ar"
    t.string "country_code"
    t.string "country_name"
    t.integer "total_routes_count"
    t.text "routes_data"
    t.text "current_routes_count"
    t.text "routes_data_ar"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "in_from_to_contents", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "city_code", collation: "latin1_swedish_ci"
    t.text "en_from_content", limit: 4294967295, collation: "latin1_swedish_ci"
    t.text "en_to_content", limit: 4294967295, collation: "latin1_swedish_ci"
    t.text "hi_from_content", limit: 4294967295, collation: "latin1_swedish_ci"
    t.text "hi_to_content", limit: 4294967295, collation: "latin1_swedish_ci"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "city_name", collation: "latin1_swedish_ci"
  end

  create_table "kw_airline_contents", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "carrier_code"
    t.string "carrier_name"
    t.string "country_code"
    t.string "icoa_code"
    t.string "meta_tile_en"
    t.string "meta_title_ar"
    t.string "meta_description_en"
    t.string "meta_description_ar"
    t.text "overview_content_en", limit: 4294967295
    t.text "overview_content_ar", limit: 4294967295
    t.text "baggage_content_en", limit: 4294967295
    t.text "baggage_content_ar", limit: 4294967295
    t.text "cancellation_content_en", limit: 4294967295
    t.text "cancellation_content_ar", limit: 4294967295
    t.text "customer_support_content_en", limit: 4294967295
    t.text "customer_support_content_ar", limit: 4294967295
    t.text "pnr_content_en", limit: 4294967295
    t.text "pnr_content_ar", limit: 4294967295
    t.text "web_checkin_content_en", limit: 4294967295
    t.text "web_checkin_content_ar", limit: 4294967295
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "kw_flight_schedule_collectives", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "carrier_code"
    t.integer "flight_no"
    t.string "dep_time"
    t.string "arr_time"
    t.string "duration"
    t.string "days_of_operation"
    t.string "dep_city_code"
    t.string "arr_city_code"
    t.string "dep_country_code"
    t.string "arr_country_code"
    t.bigint "unique_route_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["unique_route_id"], name: "index_kw_flight_schedule_collectives_on_unique_route_id"
  end

  create_table "om_airline_contents", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "carrier_code"
    t.string "carrier_name"
    t.string "country_code"
    t.string "icoa_code"
    t.string "meta_tile_en"
    t.string "meta_title_ar"
    t.string "meta_description_en"
    t.string "meta_description_ar"
    t.text "overview_content_en", limit: 4294967295
    t.text "overview_content_ar", limit: 4294967295
    t.text "baggage_content_en", limit: 4294967295
    t.text "baggage_content_ar", limit: 4294967295
    t.text "cancellation_content_en", limit: 4294967295
    t.text "cancellation_content_ar", limit: 4294967295
    t.text "customer_support_content_en", limit: 4294967295
    t.text "customer_support_content_ar", limit: 4294967295
    t.text "pnr_content_en", limit: 4294967295
    t.text "pnr_content_ar", limit: 4294967295
    t.text "web_checkin_content_en", limit: 4294967295
    t.text "web_checkin_content_ar", limit: 4294967295
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "om_flight_schedule_collectives", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "carrier_code"
    t.integer "flight_no"
    t.string "dep_time"
    t.string "arr_time"
    t.string "duration"
    t.string "days_of_operation"
    t.string "dep_city_code"
    t.string "arr_city_code"
    t.string "dep_country_code"
    t.string "arr_country_code"
    t.bigint "unique_route_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["unique_route_id"], name: "index_om_flight_schedule_collectives_on_unique_route_id"
  end

  create_table "package_flight_schedules", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "carrier_code"
    t.string "carrier_brand"
    t.string "carrier_logo"
    t.string "flight_no"
    t.string "dep_airport_code"
    t.string "dep_city_code"
    t.string "dep_city_name"
    t.string "dep_country_code"
    t.string "arr_airport_code"
    t.string "arr_city_code"
    t.string "arr_city_name"
    t.string "arr_country_code"
    t.string "dep_time"
    t.string "arr_time"
    t.integer "arrival_day_marker"
    t.string "elapsed_journey_time"
    t.integer "flight_count"
    t.date "effective_from"
    t.date "effective_to"
    t.string "day_of_operation"
    t.integer "stop"
    t.string "intermediate_airports"
    t.string "full_routing"
    t.string "is_active"
    t.string "brand_type"
    t.integer "weekly_count"
    t.string "icoa_code"
    t.string "data_source"
    t.integer "distance"
    t.timestamp "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["dep_city_code", "arr_city_code", "carrier_code"], name: "indicies"
  end

  create_table "qa_airline_contents", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "carrier_code"
    t.string "carrier_name"
    t.string "country_code"
    t.string "icoa_code"
    t.string "meta_tile_en"
    t.string "meta_title_ar"
    t.string "meta_description_en"
    t.string "meta_description_ar"
    t.text "overview_content_en", limit: 4294967295
    t.text "overview_content_ar", limit: 4294967295
    t.text "baggage_content_en", limit: 4294967295
    t.text "baggage_content_ar", limit: 4294967295
    t.text "cancellation_content_en", limit: 4294967295
    t.text "cancellation_content_ar", limit: 4294967295
    t.text "customer_support_content_en", limit: 4294967295
    t.text "customer_support_content_ar", limit: 4294967295
    t.text "pnr_content_en", limit: 4294967295
    t.text "pnr_content_ar", limit: 4294967295
    t.text "web_checkin_content_en", limit: 4294967295
    t.text "web_checkin_content_ar", limit: 4294967295
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "qa_flight_schedule_collectives", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "carrier_code"
    t.integer "flight_no"
    t.string "dep_time"
    t.string "arr_time"
    t.string "duration"
    t.string "days_of_operation"
    t.string "dep_city_code"
    t.string "arr_city_code"
    t.string "dep_country_code"
    t.string "arr_country_code"
    t.bigint "unique_route_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["unique_route_id"], name: "index_qa_flight_schedule_collectives_on_unique_route_id"
  end

  create_table "sa_airline_contents", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "carrier_code"
    t.string "carrier_name"
    t.string "country_code"
    t.string "icoa_code"
    t.string "meta_tile_en"
    t.string "meta_title_ar"
    t.string "meta_description_en"
    t.string "meta_description_ar"
    t.text "overview_content_en", limit: 4294967295
    t.text "overview_content_ar", limit: 4294967295
    t.text "baggage_content_en", limit: 4294967295
    t.text "baggage_content_ar", limit: 4294967295
    t.text "cancellation_content_en", limit: 4294967295
    t.text "cancellation_content_ar", limit: 4294967295
    t.text "customer_support_content_en", limit: 4294967295
    t.text "customer_support_content_ar", limit: 4294967295
    t.text "pnr_content_en", limit: 4294967295
    t.text "pnr_content_ar", limit: 4294967295
    t.text "web_checkin_content_en", limit: 4294967295
    t.text "web_checkin_content_ar", limit: 4294967295
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sa_flight_schedule_collectives", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "carrier_code"
    t.integer "flight_no"
    t.string "dep_time"
    t.string "arr_time"
    t.string "duration"
    t.string "days_of_operation"
    t.string "dep_city_code"
    t.string "arr_city_code"
    t.string "dep_country_code"
    t.string "arr_country_code"
    t.bigint "unique_route_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["unique_route_id"], name: "index_sa_flight_schedule_collectives_on_unique_route_id"
  end

  create_table "unique_routes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "dep_city_code"
    t.string "arr_city_code"
    t.string "dep_airport_code"
    t.string "arr_airport_code"
    t.string "dep_country_code"
    t.string "arr_country_code"
    t.integer "weekly_flights_count"
    t.integer "distance"
    t.integer "hop"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "dep_city_name"
    t.string "arr_city_name"
    t.string "schedule_route_url"
    t.string "ticket_route_url"
    t.index ["schedule_route_url", "ticket_route_url", "dep_city_code", "arr_city_code"], name: "indecies"
  end

  add_foreign_key "ae_flight_schedule_collectives", "unique_routes"
  add_foreign_key "airline_brand_collectives", "unique_routes"
  add_foreign_key "bh_flight_schedule_collectives", "unique_routes"
  add_foreign_key "collectives", "unique_routes"
  add_foreign_key "in_flight_schedule_collectives", "unique_routes"
  add_foreign_key "kw_flight_schedule_collectives", "unique_routes"
  add_foreign_key "om_flight_schedule_collectives", "unique_routes"
  add_foreign_key "qa_flight_schedule_collectives", "unique_routes"
  add_foreign_key "sa_flight_schedule_collectives", "unique_routes"
end
