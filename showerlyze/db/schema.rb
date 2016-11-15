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

ActiveRecord::Schema.define(version: 20161110090142) do

  create_table "bathrooms", force: :cascade do |t|
    t.string   "name"
    t.integer  "house_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "bathrooms", ["house_id"], name: "index_bathrooms_on_house_id"

  create_table "data_points", force: :cascade do |t|
    t.integer  "shower_id"
    t.float    "flow_rate"
    t.float    "temp"
    t.datetime "time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "data_points", ["shower_id"], name: "index_data_points_on_shower_id"

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "owner_type"
    t.integer  "owner_id"
  end

  add_index "delayed_jobs", ["owner_type", "owner_id"], name: "index_delayed_jobs_on_owner_type_and_owner_id"
  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority"

  create_table "houses", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "showers", force: :cascade do |t|
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "bathroom_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "user_id"
    t.boolean  "shower_on"
    t.boolean  "temp_ready"
  end

  add_index "showers", ["bathroom_id"], name: "index_showers_on_bathroom_id"
  add_index "showers", ["user_id"], name: "index_showers_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "password_digest"
    t.integer  "house_id"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "phone_number"
    t.string   "passcode"
    t.float    "preferred_temp"
  end

  add_index "users", ["house_id"], name: "index_users_on_house_id"

end
