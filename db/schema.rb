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

ActiveRecord::Schema.define(version: 20180417132209) do

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

  create_table "ae_airline_footers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.text "airline_footer_en", limit: 4294967295
    t.text "airline_footer_ar", limit: 4294967295
    t.text "airline_footer_en_dup", limit: 4294967295
    t.text "airline_footer_ar_dup", limit: 4294967295
    t.integer "current_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ae_flight_hop_schedule_collectives", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "carrier_code"
    t.string "dep_time"
    t.string "arr_time"
    t.string "dep_city_code"
    t.string "arr_city_code"
    t.string "dep_country_code"
    t.string "arr_country_code"
    t.string "dep_airport_code"
    t.string "arr_airport_code"
    t.string "mid_city_code"
    t.string "mid_airport_code"
    t.string "duration"
    t.integer "first_flight_no"
    t.integer "second_flight_no"
    t.string "first_carrier_code"
    t.string "second_carrier_code"
    t.string "days_of_operation"
    t.bigint "unique_hop_route_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["unique_hop_route_id"], name: "index_ae_flight_hop_schedule_collectives_on_unique_hop_route_id"
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

  create_table "ae_footers", id: :integer, default: nil, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "city_code"
    t.string "city_name"
    t.string "country_code"
    t.string "country_name"
    t.integer "total_routes_count"
    t.text "routes_data"
    t.integer "current_routes_count"
    t.string "city_name_ar"
    t.text "routes_data_ar"
    t.datetime "updated_at"
  end

  create_table "ae_from_to_contents", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "city_code"
    t.text "en_from_content"
    t.text "en_to_content"
    t.text "ar_from_content"
    t.text "ar_to_content"
    t.string "city_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ae_hotel_apis", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "city_name"
    t.string "country_code"
    t.string "country_name"
    t.text "hotel_data", limit: 4294967295
    t.text "properties", limit: 4294967295
    t.text "star_data", limit: 4294967295
    t.text "local_cities_data", limit: 4294967295
    t.text "local_activities", limit: 4294967295
    t.integer "current_iteration_count"
    t.integer "total_iteration_count"
    t.text "wayto_go", limit: 4294967295
    t.integer "local_activities_total"
    t.integer "local_activities_current"
  end

  create_table "ae_volume_routes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "dep_city_code"
    t.string "arr_city_code"
    t.string "dep_city_name_en"
    t.string "arr_city_name_en"
    t.string "dep_city_name_ar"
    t.string "arr_city_name_ar"
    t.string "url"
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
    t.index ["carrier_code", "carrier_name"], name: "indicies"
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

  create_table "airline_footers", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "id", null: false
    t.text "airline_footer_en", limit: 4294967295
    t.text "airline_footer_ar", limit: 4294967295
    t.text "airline_footer_en_dup", limit: 4294967295
    t.text "airline_footer_ar_dup", limit: 4294967295
    t.integer "current_count"
  end

  create_table "airports", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "id"
    t.timestamp "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
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
    t.string "airport_name_ar"
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

  create_table "bh_flight_hop_schedule_collectives", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "carrier_code"
    t.string "dep_time"
    t.string "arr_time"
    t.string "dep_city_code"
    t.string "arr_city_code"
    t.string "dep_country_code"
    t.string "arr_country_code"
    t.string "dep_airport_code"
    t.string "arr_airport_code"
    t.string "mid_city_code"
    t.string "mid_airport_code"
    t.string "duration"
    t.integer "first_flight_no"
    t.integer "second_flight_no"
    t.string "first_carrier_code"
    t.string "second_carrier_code"
    t.string "days_of_operation"
    t.bigint "unique_hop_route_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["unique_hop_route_id"], name: "index_bh_flight_hop_schedule_collectives_on_unique_hop_route_id"
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

  create_table "bh_footers", id: :integer, default: nil, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "city_code"
    t.string "city_name"
    t.string "country_code"
    t.string "country_name"
    t.integer "total_routes_count"
    t.text "routes_data"
    t.integer "current_routes_count"
    t.string "city_name_ar"
    t.text "routes_data_ar"
    t.datetime "updated_at"
  end

  create_table "bh_from_to_contents", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "city_code"
    t.text "en_from_content"
    t.text "en_to_content"
    t.text "ar_from_content"
    t.text "ar_to_content"
    t.string "city_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "bh_hotel_apis", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "city_name"
    t.string "country_code"
    t.string "country_name"
    t.text "hotel_data", limit: 4294967295
    t.text "properties", limit: 4294967295
    t.text "star_data", limit: 4294967295
    t.text "local_cities_data", limit: 4294967295
    t.text "local_activities", limit: 4294967295
    t.integer "current_iteration_count"
    t.integer "total_iteration_count"
    t.text "wayto_go", limit: 4294967295
    t.integer "local_activities_total"
    t.integer "local_activities_current"
  end

  create_table "bh_volume_routes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "dep_city_code"
    t.string "arr_city_code"
    t.string "dep_city_name_en"
    t.string "arr_city_name_en"
    t.string "dep_city_name_ar"
    t.string "arr_city_name_ar"
    t.string "url"
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
    t.string "from_url"
    t.string "to_url"
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
    t.datetime "updated_at"
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

  create_table "in_flight_hop_schedule_collectives", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "carrier_code"
    t.string "dep_time"
    t.string "arr_time"
    t.string "dep_city_code"
    t.string "arr_city_code"
    t.string "dep_country_code"
    t.string "arr_country_code"
    t.string "dep_airport_code"
    t.string "arr_airport_code"
    t.string "mid_city_code"
    t.string "mid_airport_code"
    t.string "mid_country_code"
    t.string "duration"
    t.integer "first_flight_no"
    t.integer "second_flight_no"
    t.string "first_carrier_code"
    t.string "second_carrier_code"
    t.string "days_of_operation"
    t.bigint "unique_hop_route_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dep_city_code", "arr_city_code"], name: "indicies"
    t.index ["unique_hop_route_id"], name: "index_in_flight_hop_schedule_collectives_on_unique_hop_route_id"
  end

  create_table "in_flight_schedule_collectives", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
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

  create_table "in_footers", id: :integer, default: nil, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "city_code"
    t.string "city_name"
    t.string "country_code"
    t.string "country_name"
    t.integer "total_routes_count"
    t.text "routes_data"
    t.integer "current_routes_count"
    t.string "city_name_ar"
    t.text "routes_data_ar"
    t.datetime "updated_at"
  end

  create_table "in_from_to_contents", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "city_code"
    t.text "en_from_content", limit: 4294967295
    t.text "en_to_content", limit: 4294967295
    t.text "hi_from_content", limit: 4294967295
    t.text "hi_to_content", limit: 4294967295
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "city_name"
  end

  create_table "in_hotel_apis", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "city_name"
    t.string "country_code"
    t.string "country_name"
    t.text "hotel_data", limit: 4294967295
    t.text "properties", limit: 4294967295
    t.text "star_data", limit: 4294967295
    t.text "local_cities_data", limit: 4294967295
    t.text "local_activities", limit: 4294967295
    t.integer "current_iteration_count"
    t.integer "total_iteration_count"
    t.text "wayto_go", limit: 4294967295
    t.integer "local_activities_total"
    t.integer "local_activities_current"
  end

  create_table "in_volume_routes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "dep_city_code"
    t.string "arr_city_code"
    t.string "dep_city_name_en"
    t.string "arr_city_name_en"
    t.string "dep_city_name_hi"
    t.string "arr_city_name_hi"
    t.string "url"
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

  create_table "kw_flight_hop_schedule_collectives", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "carrier_code"
    t.string "dep_time"
    t.string "arr_time"
    t.string "dep_city_code"
    t.string "arr_city_code"
    t.string "dep_country_code"
    t.string "arr_country_code"
    t.string "dep_airport_code"
    t.string "arr_airport_code"
    t.string "mid_city_code"
    t.string "mid_airport_code"
    t.string "duration"
    t.integer "first_flight_no"
    t.integer "second_flight_no"
    t.string "first_carrier_code"
    t.string "second_carrier_code"
    t.string "days_of_operation"
    t.bigint "unique_hop_route_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["unique_hop_route_id"], name: "index_kw_flight_hop_schedule_collectives_on_unique_hop_route_id"
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

  create_table "kw_footers", id: :integer, default: nil, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "city_code"
    t.string "city_name"
    t.string "country_code"
    t.string "country_name"
    t.integer "total_routes_count"
    t.text "routes_data"
    t.integer "current_routes_count"
    t.string "city_name_ar"
    t.text "routes_data_ar"
    t.datetime "updated_at"
  end

  create_table "kw_from_to_contents", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "city_code"
    t.text "en_from_content"
    t.text "en_to_content"
    t.text "ar_from_content"
    t.text "ar_to_content"
    t.string "city_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "kw_hotel_apis", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "city_name"
    t.string "country_code"
    t.string "country_name"
    t.text "hotel_data", limit: 4294967295
    t.text "properties", limit: 4294967295
    t.text "star_data", limit: 4294967295
    t.text "local_cities_data", limit: 4294967295
    t.text "local_activities", limit: 4294967295
    t.integer "current_iteration_count"
    t.integer "total_iteration_count"
    t.text "wayto_go", limit: 4294967295
    t.integer "local_activities_total"
    t.integer "local_activities_current"
  end

  create_table "kw_volume_routes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "dep_city_code"
    t.string "arr_city_code"
    t.string "dep_city_name_en"
    t.string "arr_city_name_en"
    t.string "dep_city_name_ar"
    t.string "arr_city_name_ar"
    t.string "url"
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

  create_table "om_flight_hop_schedule_collectives", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "carrier_code"
    t.string "dep_time"
    t.string "arr_time"
    t.string "dep_city_code"
    t.string "arr_city_code"
    t.string "dep_country_code"
    t.string "arr_country_code"
    t.string "dep_airport_code"
    t.string "arr_airport_code"
    t.string "mid_city_code"
    t.string "mid_airport_code"
    t.string "duration"
    t.integer "first_flight_no"
    t.integer "second_flight_no"
    t.string "first_carrier_code"
    t.string "second_carrier_code"
    t.string "days_of_operation"
    t.bigint "unique_hop_route_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["unique_hop_route_id"], name: "index_om_flight_hop_schedule_collectives_on_unique_hop_route_id"
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

  create_table "om_footers", id: :integer, default: nil, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "city_code"
    t.string "city_name"
    t.string "country_code"
    t.string "country_name"
    t.integer "total_routes_count"
    t.text "routes_data"
    t.integer "current_routes_count"
    t.string "city_name_ar"
    t.text "routes_data_ar"
    t.datetime "updated_at"
  end

  create_table "om_from_to_contents", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "city_code"
    t.text "en_from_content"
    t.text "en_to_content"
    t.text "ar_from_content"
    t.text "ar_to_content"
    t.string "city_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "om_hotel_apis", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "city_name"
    t.string "country_code"
    t.string "country_name"
    t.text "hotel_data", limit: 4294967295
    t.text "properties", limit: 4294967295
    t.text "star_data", limit: 4294967295
    t.text "local_cities_data", limit: 4294967295
    t.text "local_activities", limit: 4294967295
    t.integer "current_iteration_count"
    t.integer "total_iteration_count"
    t.text "wayto_go", limit: 4294967295
    t.integer "local_activities_total"
    t.integer "local_activities_current"
  end

  create_table "om_volume_routes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "dep_city_code"
    t.string "arr_city_code"
    t.string "dep_city_name_en"
    t.string "arr_city_name_en"
    t.string "dep_city_name_ar"
    t.string "arr_city_name_ar"
    t.string "url"
  end

  create_table "package_flight_hop_schedules", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "dep_city_code"
    t.string "dep_airport_code"
    t.string "dep_city_name"
    t.string "arr_city_code"
    t.string "arr_airport_code"
    t.string "arr_city_name"
    t.date "effective_from"
    t.date "effective_to"
    t.string "day_of_operation", limit: 7
    t.integer "arrival_day_marker"
    t.string "elapsed_journey_time"
    t.string "dep_time"
    t.string "arr_time"
    t.integer "flight_count"
    t.integer "distance"
    t.string "dep_country_code"
    t.string "arr_country_code"
    t.string "l1_dep_city_code"
    t.string "l1_dep_city_name"
    t.string "l1_dep_airport_code"
    t.string "l1_arr_city_code"
    t.string "l1_arr_city_name"
    t.string "l1_arr_airport_code"
    t.string "l1_carrier_code"
    t.string "l1_carrier_brand"
    t.string "l1_flight_no"
    t.date "l1_effective_from"
    t.date "l1_effective_to"
    t.string "l1_day_of_operation", limit: 7
    t.string "l1_dep_time"
    t.string "l1_arr_time"
    t.integer "l1_arrival_day_marker"
    t.string "l1_elapsed_journey_time", limit: 20
    t.integer "l1_stop"
    t.integer "l1_distance"
    t.string "l1_dep_country_code"
    t.string "l1_arr_country_code"
    t.integer "l1_flight_count"
    t.string "l2_dep_city_code"
    t.string "l2_dep_city_name"
    t.string "l2_dep_airport_code"
    t.string "l2_arr_city_code"
    t.string "l2_arr_city_name"
    t.string "l2_arr_airport_code"
    t.string "l2_carrier_code"
    t.string "l2_carrier_brand"
    t.string "l2_flight_no"
    t.date "l2_effective_from"
    t.date "l2_effective_to"
    t.string "l2_day_of_operation", limit: 7
    t.string "l2_dep_time"
    t.string "l2_arr_time"
    t.integer "l2_arrival_day_marker"
    t.string "l2_elapsed_journey_time", limit: 20
    t.integer "l2_stop"
    t.integer "l2_distance"
    t.integer "l2_flight_count"
    t.string "l2_dep_country_code"
    t.string "l2_arr_country_code"
    t.timestamp "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.string "carrier_code"
    t.string "carrier_brand"
    t.index ["dep_city_code", "arr_city_code", "l1_arr_city_code"], name: "cities"
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

  create_table "qa_flight_hop_schedule_collectives", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "carrier_code"
    t.string "dep_time"
    t.string "arr_time"
    t.string "dep_city_code"
    t.string "arr_city_code"
    t.string "dep_country_code"
    t.string "arr_country_code"
    t.string "dep_airport_code"
    t.string "arr_airport_code"
    t.string "mid_city_code"
    t.string "mid_airport_code"
    t.string "duration"
    t.integer "first_flight_no"
    t.integer "second_flight_no"
    t.string "first_carrier_code"
    t.string "second_carrier_code"
    t.string "days_of_operation"
    t.bigint "unique_hop_route_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["unique_hop_route_id"], name: "index_qa_flight_hop_schedule_collectives_on_unique_hop_route_id"
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

  create_table "qa_footers", id: :integer, default: nil, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "city_code"
    t.string "city_name"
    t.string "country_code"
    t.string "country_name"
    t.integer "total_routes_count"
    t.text "routes_data"
    t.integer "current_routes_count"
    t.string "city_name_ar"
    t.text "routes_data_ar"
    t.datetime "updated_at"
  end

  create_table "qa_from_to_contents", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "city_code"
    t.text "en_from_content"
    t.text "en_to_content"
    t.text "ar_from_content"
    t.text "ar_to_content"
    t.string "city_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "qa_hotel_apis", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "city_name"
    t.string "country_code"
    t.string "country_name"
    t.text "hotel_data", limit: 4294967295
    t.text "properties", limit: 4294967295
    t.text "star_data", limit: 4294967295
    t.text "local_cities_data", limit: 4294967295
    t.text "local_activities", limit: 4294967295
    t.integer "current_iteration_count"
    t.integer "total_iteration_count"
    t.text "wayto_go", limit: 4294967295
    t.integer "local_activities_total"
    t.integer "local_activities_current"
  end

  create_table "qa_volume_routes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "dep_city_code"
    t.string "arr_city_code"
    t.string "dep_city_name_en"
    t.string "arr_city_name_en"
    t.string "dep_city_name_ar"
    t.string "arr_city_name_ar"
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  create_table "sa_flight_hop_schedule_collectives", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "carrier_code"
    t.string "dep_time"
    t.string "arr_time"
    t.string "dep_city_code"
    t.string "arr_city_code"
    t.string "dep_country_code"
    t.string "arr_country_code"
    t.string "dep_airport_code"
    t.string "arr_airport_code"
    t.string "mid_city_code"
    t.string "mid_airport_code"
    t.string "duration"
    t.integer "first_flight_no"
    t.integer "second_flight_no"
    t.string "first_carrier_code"
    t.string "second_carrier_code"
    t.string "days_of_operation"
    t.bigint "unique_hop_route_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["unique_hop_route_id"], name: "index_sa_flight_hop_schedule_collectives_on_unique_hop_route_id"
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

  create_table "sa_footers", id: :integer, default: nil, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "city_code"
    t.string "city_name"
    t.string "country_code"
    t.string "country_name"
    t.integer "total_routes_count"
    t.text "routes_data"
    t.integer "current_routes_count"
    t.string "city_name_ar"
    t.text "routes_data_ar"
    t.datetime "updated_at"
  end

  create_table "sa_from_to_contents", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "city_code"
    t.text "en_from_content"
    t.text "en_to_content"
    t.text "ar_from_content"
    t.text "ar_to_content"
    t.string "city_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sa_hotel_apis", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "city_name"
    t.string "country_code"
    t.string "country_name"
    t.text "hotel_data", limit: 4294967295
    t.text "properties", limit: 4294967295
    t.text "star_data", limit: 4294967295
    t.text "local_cities_data", limit: 4294967295
    t.text "local_activities", limit: 4294967295
    t.integer "current_iteration_count"
    t.integer "total_iteration_count"
    t.text "wayto_go", limit: 4294967295
    t.integer "local_activities_total"
    t.integer "local_activities_current"
  end

  create_table "sa_volume_routes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "dep_city_code"
    t.string "arr_city_code"
    t.string "dep_city_name_en"
    t.string "arr_city_name_en"
    t.string "dep_city_name_ar"
    t.string "arr_city_name_ar"
    t.string "url"
  end

  create_table "unique_hop_routes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "dep_city_code"
    t.string "arr_city_code"
    t.string "dep_airport_code"
    t.string "arr_airport_code"
    t.string "dep_country_code"
    t.string "arr_country_code"
    t.string "dep_city_name"
    t.string "arr_city_name"
    t.integer "hop"
    t.integer "distance"
    t.integer "weekly_flights_count"
    t.integer "total_flights_count"
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["url", "dep_city_code", "arr_city_code"], name: "indicies"
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
    t.string "dep_city_name_ar"
    t.string "arr_city_name_ar"
    t.string "dep_city_name_hi"
    t.string "arr_city_name_hi"
    t.index ["schedule_route_url", "ticket_route_url", "dep_city_code", "arr_city_code"], name: "indecies"
  end

  add_foreign_key "ae_flight_hop_schedule_collectives", "unique_hop_routes"
  add_foreign_key "ae_flight_schedule_collectives", "unique_routes"
  add_foreign_key "airline_brand_collectives", "unique_routes"
  add_foreign_key "bh_flight_hop_schedule_collectives", "unique_hop_routes"
  add_foreign_key "bh_flight_schedule_collectives", "unique_routes"
  add_foreign_key "collectives", "unique_routes"
  add_foreign_key "in_flight_hop_schedule_collectives", "unique_hop_routes"
  add_foreign_key "in_flight_schedule_collectives", "unique_routes"
  add_foreign_key "kw_flight_hop_schedule_collectives", "unique_hop_routes"
  add_foreign_key "kw_flight_schedule_collectives", "unique_routes"
  add_foreign_key "om_flight_hop_schedule_collectives", "unique_hop_routes"
  add_foreign_key "om_flight_schedule_collectives", "unique_routes"
  add_foreign_key "qa_flight_hop_schedule_collectives", "unique_hop_routes"
  add_foreign_key "qa_flight_schedule_collectives", "unique_routes"
  add_foreign_key "sa_flight_hop_schedule_collectives", "unique_hop_routes"
  add_foreign_key "sa_flight_schedule_collectives", "unique_routes"
end
