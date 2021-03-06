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

ActiveRecord::Schema.define(version: 20150108140455) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", force: true do |t|
    t.text     "content"
    t.integer  "user_id"
    t.integer  "post_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "friendships", force: true do |t|
    t.integer  "user_id"
    t.integer  "friend_id"
    t.string   "status"
    t.datetime "accepted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "jobs", force: true do |t|
    t.string   "title"
    t.text     "content"
    t.string   "location"
    t.float    "lat"
    t.float    "lng"
    t.string   "treatment"
    t.string   "jobtype"
    t.string   "worktime"
    t.string   "leavesys"
    t.string   "availability"
    t.string   "reqnum"
    t.string   "acceptid"
    t.string   "exp"
    t.string   "education"
    t.string   "department"
    t.string   "language"
    t.string   "tool"
    t.string   "skill"
    t.string   "othercond"
    t.string   "contact"
    t.string   "emailsrc"
    t.string   "inperson"
    t.string   "telesrc"
    t.string   "other"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "joburl"
    t.datetime "last_modified"
  end

  add_index "jobs", ["joburl"], name: "index_jobs_on_joburl", unique: true, using: :btree

  create_table "posts", force: true do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",                 null: false
    t.string   "encrypted_password",     default: "",                 null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,                  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.boolean  "admin"
    t.string   "provider"
    t.string   "uid"
    t.string   "oauth_token"
    t.datetime "oauth_expires_at"
    t.string   "image",                  default: "profile-icon.png"
    t.string   "image_large",            default: "profile-icon.png"
  end

  add_index "users", ["email", "provider"], name: "index_users_on_email_and_provider", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
