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

ActiveRecord::Schema.define(version: 20150519224352) do

  create_table "attachments", force: :cascade do |t|
    t.integer  "code_id",    limit: 4
    t.string   "image",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "codes", force: :cascade do |t|
    t.string   "title",      limit: 255,   default: ""
    t.text     "code",       limit: 65535
    t.string   "code_url",   limit: 255,   default: ""
    t.integer  "status",     limit: 1,     default: 1
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "editable",   limit: 1,     default: true
    t.integer  "user_id",    limit: 4
    t.string   "show_from",  limit: 255
  end

  add_index "codes", ["user_id"], name: "index_codes_on_user_id", using: :btree

  create_table "mad_chatter_messages", force: :cascade do |t|
    t.string   "text",       limit: 255
    t.string   "html",       limit: 255
    t.integer  "room_id",    limit: 4
    t.integer  "author_id",  limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mad_chatter_rooms", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "owner_id",   limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "messages", force: :cascade do |t|
    t.string   "text",       limit: 255
    t.integer  "user_id",    limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "messages", ["user_id"], name: "index_messages_on_user_id", using: :btree

  create_table "private_messages", force: :cascade do |t|
    t.integer  "user_from_id",         limit: 4
    t.integer  "user_to_id",           limit: 4
    t.string   "title",                limit: 255
    t.text     "text",                 limit: 65535
    t.string   "file",                 limit: 255
    t.boolean  "deleted_by_from_user", limit: 1,     default: false
    t.boolean  "deleted_by_to_user",   limit: 1,     default: false
    t.boolean  "read",                 limit: 1,     default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "to_message_id",        limit: 4
  end

  create_table "profiles", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "interests",  limit: 255
    t.string   "exp",        limit: 255
    t.string   "about_me",   limit: 255
    t.string   "signature",  limit: 255
    t.integer  "user_id",    limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "avatar",     limit: 255
  end

  add_index "profiles", ["user_id"], name: "index_profiles_on_user_id", using: :btree

  create_table "simple_captcha_data", force: :cascade do |t|
    t.string   "key",        limit: 40
    t.string   "value",      limit: 6
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "simple_captcha_data", ["key"], name: "idx_key", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "username",               limit: 255, default: "", null: false
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",      limit: 255
    t.integer  "failed_attempts",        limit: 4,   default: 0,  null: false
    t.string   "unlock_token",           limit: 255
    t.datetime "locked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

end
