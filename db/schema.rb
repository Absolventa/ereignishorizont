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

ActiveRecord::Schema.define(version: 20150202102148) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "alarm_mappings", force: :cascade do |t|
    t.integer  "alarm_id"
    t.integer  "expected_event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "alarm_mappings", ["alarm_id"], name: "index_alarm_mappings_on_alarm_id", using: :btree
  add_index "alarm_mappings", ["expected_event_id"], name: "index_alarm_mappings_on_expected_event_id", using: :btree

  create_table "alarm_notifications", force: :cascade do |t|
    t.integer  "expected_event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "remote_side_id"
  end

  add_index "alarm_notifications", ["expected_event_id"], name: "index_alarm_notifications_on_expected_event_id", using: :btree
  add_index "alarm_notifications", ["remote_side_id"], name: "index_alarm_notifications_on_remote_side_id", using: :btree

  create_table "alarms", force: :cascade do |t|
    t.string   "title",           limit: 255
    t.string   "action",          limit: 255
    t.string   "email_recipient", limit: 255
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slack_url"
    t.string   "slack_channel"
    t.string   "webhook_url"
    t.string   "webhook_method"
    t.json     "webhook_payload"
  end

  create_table "expected_events", force: :cascade do |t|
    t.text     "title"
    t.boolean  "weekday_0"
    t.boolean  "weekday_1"
    t.boolean  "weekday_2"
    t.boolean  "weekday_3"
    t.boolean  "weekday_4"
    t.boolean  "weekday_5"
    t.boolean  "weekday_6"
    t.string   "matching_direction", limit: 255
    t.integer  "final_hour"
    t.date     "started_at"
    t.date     "ended_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "remote_side_id"
    t.integer  "day_of_month"
  end

  add_index "expected_events", ["remote_side_id"], name: "index_expected_events_on_remote_side_id", using: :btree

  create_table "incoming_events", force: :cascade do |t|
    t.text     "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "expected_event_id"
    t.integer  "remote_side_id"
    t.text     "content"
  end

  add_index "incoming_events", ["expected_event_id"], name: "index_incoming_events_on_expected_event_id", using: :btree

  create_table "remote_sides", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "api_token",  limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255
    t.string   "password_digest",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "auth_token",             limit: 255
    t.string   "password_reset_token",   limit: 255
    t.datetime "password_reset_sent_at"
    t.boolean  "admin"
    t.string   "time_zone",              limit: 255, default: "UTC"
  end

end
