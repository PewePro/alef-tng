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

ActiveRecord::Schema.define(version: 20150306144552) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answers", force: :cascade do |t|
    t.integer  "learning_object_id", null: false
    t.text     "answer_text"
    t.boolean  "is_correct"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "concepts", force: :cascade do |t|
    t.integer  "setup_id",   null: false
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "concepts_learning_objects", force: :cascade do |t|
    t.integer "concept_id",         null: false
    t.integer "learning_object_id", null: false
  end

  create_table "concepts_weeks", force: :cascade do |t|
    t.integer "week_id",    null: false
    t.integer "concept_id", null: false
  end

  create_table "learning_objects", force: :cascade do |t|
    t.string   "lo_id"
    t.string   "type"
    t.text     "question_text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "setups", force: :cascade do |t|
    t.string   "name"
    t.datetime "first_week_at"
    t.integer  "week_count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "setups_users", force: :cascade do |t|
    t.integer  "setup_id",   null: false
    t.integer  "user_id",    null: false
    t.boolean  "is_valid"
    t.boolean  "is_tracked"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_to_lo_relations", force: :cascade do |t|
    t.integer  "user_id",            null: false
    t.integer  "learning_object_id", null: false
    t.integer  "setup_id",           null: false
    t.string   "type"
    t.string   "interaction"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "login"
    t.string   "aisid"
    t.integer  "role"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "password"
    t.string   "salt"
    t.string   "authorization"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "weeks", force: :cascade do |t|
    t.integer "setup_id"
    t.integer "number"
  end

  add_foreign_key "answers", "learning_objects"
  add_foreign_key "concepts", "setups"
  add_foreign_key "concepts_learning_objects", "concepts"
  add_foreign_key "concepts_learning_objects", "learning_objects"
  add_foreign_key "concepts_weeks", "concepts"
  add_foreign_key "concepts_weeks", "weeks"
  add_foreign_key "setups_users", "setups"
  add_foreign_key "setups_users", "users"
  add_foreign_key "user_to_lo_relations", "learning_objects"
  add_foreign_key "user_to_lo_relations", "setups"
  add_foreign_key "user_to_lo_relations", "users"
  add_foreign_key "weeks", "setups"
end
