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

ActiveRecord::Schema.define(version: 20150828162410) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "courses", force: :cascade do |t|
    t.string   "title",          limit: 255
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "summary",        limit: 255
    t.string   "course_number",  limit: 8
    t.string   "short_title",    limit: 30
    t.string   "evaluation_url"
  end

  create_table "enrollments", force: :cascade do |t|
    t.integer  "section_id"
    t.integer  "user_id"
    t.datetime "completed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.uuid     "ical_event_uid"
    t.boolean  "waiting",        default: false
    t.boolean  "no_show",        default: false
  end

  create_table "parts", force: :cascade do |t|
    t.integer  "section_id"
    t.string   "location",   limit: 255
    t.datetime "starts_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "duration"
  end

  create_table "sections", force: :cascade do |t|
    t.integer  "seats"
    t.integer  "course_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "section_number", limit: 6
    t.integer  "instructor_id"
    t.string   "alert_email"
  end

  create_table "settings", force: :cascade do |t|
    t.string   "name",                               null: false
    t.string   "value",                              null: false
    t.string   "last_changed_by", default: "system"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  add_index "settings", ["name"], name: "index_settings_on_name", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "username",               limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "email",                  limit: 255
    t.string   "first_name",             limit: 255
    t.string   "last_name",              limit: 255
    t.integer  "employee_id"
    t.string   "phone_number",           limit: 255
    t.string   "department",             limit: 255
    t.string   "mailbox",                limit: 255
    t.string   "nickname",               limit: 255
    t.integer  "role"
    t.string   "computer_preference",    limit: 8
  end

  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

end
