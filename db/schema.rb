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

ActiveRecord::Schema.define(version: 20130806100354) do

  create_table "alarms", force: true do |t|
    t.string  "title"
    t.string  "action"
    t.integer "expected_event_id"
    t.string  "recipient_email"
    t.text    "message"
  end

  add_index "alarms", ["expected_event_id"], name: "index_alarms_on_expected_event_id"

  create_table "expected_events", force: true do |t|
    t.text "title"
  end

  create_table "incoming_events", force: true do |t|
    t.text     "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "expected_event_id"
  end

  add_index "incoming_events", ["expected_event_id"], name: "index_incoming_events_on_expected_event_id"

  create_table "users", force: true do |t|
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "auth_token"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
  end

end
