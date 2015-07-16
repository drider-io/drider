# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150716083348) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "car_locations", force: :cascade do |t|
    t.geography "r",              limit: {:srid=>4326, :type=>"point", :geographic=>true}
    t.geometry  "m",              limit: {:srid=>3785, :type=>"point"}
    t.integer   "car_session_id",                                                          null: false
    t.float     "accuracy"
    t.datetime  "time",                                                                    null: false
    t.string    "provider"
    t.integer   "user_id"
    t.datetime  "created_at",                                                              null: false
    t.datetime  "updated_at",                                                              null: false
  end

  add_index "car_locations", ["car_session_id"], name: "index_car_locations_on_car_session_id", using: :btree

# Could not dump table "car_requests" because of following StandardError
#   Unknown type 'request_status' for column 'status'

  create_table "car_route_stats", force: :cascade do |t|
    t.integer  "car_route_id", null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "car_routes", force: :cascade do |t|
    t.geometry "route",      limit: {:srid=>3785, :type=>"line_string"}
    t.integer  "user_id",                                                               null: false
    t.boolean  "is_actual",                                              default: true, null: false
    t.datetime "created_at",                                                            null: false
    t.datetime "updated_at",                                                            null: false
  end

  add_index "car_routes", ["is_actual"], name: "index_car_routes_on_is_actual", using: :btree

  create_table "car_searches", force: :cascade do |t|
    t.integer  "user_id",                                            null: false
    t.datetime "scheduled_to"
    t.string   "from_title",                                         null: false
    t.string   "to_title",                                           null: false
    t.boolean  "pinned",                                             null: false
    t.geometry "from_m",       limit: {:srid=>3785, :type=>"point"}, null: false
    t.geometry "to_m",         limit: {:srid=>3785, :type=>"point"}, null: false
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
  end

  add_index "car_searches", ["user_id"], name: "index_car_searches_on_user_id", using: :btree

  create_table "car_sessions", force: :cascade do |t|
    t.integer  "number",                                   null: false
    t.string   "device_identifier",                        null: false
    t.string   "client_version",                           null: false
    t.string   "client_os_version",                        null: false
    t.integer  "user_id",                                  null: false
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.string   "android_model"
    t.boolean  "is_gps_available"
    t.boolean  "is_location_enabled"
    t.boolean  "is_location_available"
    t.integer  "is_google_play_available"
    t.integer  "android_sdk"
    t.string   "android_manufacturer"
    t.integer  "client_version_code"
    t.boolean  "processed",                default: false
    t.integer  "car_route_id"
  end

  add_index "car_sessions", ["number", "user_id"], name: "car_session_user_index", unique: true, using: :btree
  add_index "car_sessions", ["number"], name: "index_car_sessions_on_number", using: :btree
  add_index "car_sessions", ["processed"], name: "index_car_sessions_on_processed", using: :btree

  create_table "messages", force: :cascade do |t|
    t.integer  "from_id"
    t.integer  "to_id"
    t.integer  "car_request_id"
    t.string   "body"
    t.datetime "seen_at"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "messages", ["car_request_id"], name: "index_messages_on_car_request_id", using: :btree
  add_index "messages", ["from_id"], name: "index_messages_on_from_id", using: :btree
  add_index "messages", ["to_id"], name: "index_messages_on_to_id", using: :btree

  create_table "points", force: :cascade do |t|
    t.geography "lonlat",     limit: {:srid=>4326, :type=>"point", :geographic=>true}
    t.float     "accuracy"
    t.datetime  "time"
    t.datetime  "created_at"
    t.datetime  "updated_at"
  end

  create_table "test", id: false, force: :cascade do |t|
    t.geometry "ll", limit: {:srid=>3857, :type=>"point"}
  end

  create_table "users", force: :cascade do |t|
    t.string   "device_identifier"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "image_url"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["provider", "uid"], name: "index_users_on_provider_and_uid", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "car_requests", "car_routes"
  add_foreign_key "car_requests", "users", column: "driver_id"
  add_foreign_key "car_requests", "users", column: "passenger_id"
  add_foreign_key "car_searches", "users"
  add_foreign_key "car_sessions", "car_routes"
  add_foreign_key "messages", "car_requests"
  add_foreign_key "messages", "users", column: "from_id"
  add_foreign_key "messages", "users", column: "to_id"
end
