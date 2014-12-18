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

ActiveRecord::Schema.define(version: 20141216205627) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "courses", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "summary"
    t.string   "course_number", limit: 8
    t.string   "short_title",   limit: 30
  end

  create_table "enrollments", force: true do |t|
    t.integer  "section_id"
    t.integer  "user_id"
    t.datetime "completed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.uuid     "ical_event_uid"
    t.boolean  "waiting",        default: false
  end

  create_table "parts", force: true do |t|
    t.integer  "section_id"
    t.string   "location"
    t.datetime "starts_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "duration"
  end

  create_table "sections", force: true do |t|
    t.integer  "seats"
    t.integer  "course_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "section_number", limit: 6
    t.integer  "instructor_id"
  end

  create_table "users", force: true do |t|
    t.string   "username",                         default: "", null: false
    t.string   "encrypted_password",               default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                    default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "email"
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "employee_id"
    t.string   "phone_number"
    t.string   "department"
    t.string   "mailbox"
    t.string   "nickname"
    t.integer  "role"
    t.string   "computer_preference",    limit: 8
  end

  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

end
