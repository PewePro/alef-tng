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

ActiveRecord::Schema.define(version: 20151226105657) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activity_recommender_records", force: :cascade do |t|
    t.integer "learning_object_id",                      null: false
    t.integer "relation_learning_object_id",             null: false
    t.string  "relation_type",                           null: false
    t.integer "right_answers",               default: 0, null: false
    t.integer "wrong_answers",               default: 0, null: false
  end

  add_index "activity_recommender_records", ["learning_object_id", "relation_learning_object_id", "relation_type"], name: "activity_recommender_table_index", using: :btree

  create_table "answers", force: :cascade do |t|
    t.integer  "learning_object_id", null: false
    t.text     "answer_text"
    t.boolean  "is_correct"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "concepts", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "pseudo",     default: true, null: false
    t.integer  "course_id",                 null: false
  end

  create_table "concepts_learning_objects", force: :cascade do |t|
    t.integer "concept_id",         null: false
    t.integer "learning_object_id", null: false
  end

  create_table "concepts_weeks", force: :cascade do |t|
    t.integer "week_id",    null: false
    t.integer "concept_id", null: false
  end

  create_table "courses", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "feedbacks", force: :cascade do |t|
    t.text     "message",            null: false
    t.integer  "user_id"
    t.text     "url"
    t.text     "accept"
    t.text     "user_agent"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "learning_object_id"
  end

  create_table "irt_values", force: :cascade do |t|
    t.float   "difficulty"
    t.float   "discrimination"
    t.integer "learning_object_id"
  end

  create_table "learning_objects", force: :cascade do |t|
    t.string   "lo_id"
    t.string   "type"
    t.text     "question_text"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "external_reference"
    t.binary   "image"
    t.integer  "course_id"
    t.integer  "right_answers",      default: 0
    t.integer  "wrong_answers",      default: 0
    t.string   "difficulty",         default: "unknown_difficulty"
    t.string   "importance",         default: "UNKNOWN"
  end

  create_table "recommendation_configurations", force: :cascade do |t|
    t.string  "name",                    null: false
    t.boolean "default", default: false
  end

  create_table "recommendation_linkers", force: :cascade do |t|
    t.integer "user_id",                         null: false
    t.integer "week_id",                         null: false
    t.integer "recommendation_configuration_id", null: false
  end

  create_table "recommenders", force: :cascade do |t|
    t.string "name", null: false
  end

  create_table "recommenders_options", force: :cascade do |t|
    t.integer "recommendation_configuration_id", null: false
    t.integer "recommender_id",                  null: false
    t.integer "weight",                          null: false
  end

  create_table "rooms", force: :cascade do |t|
    t.integer "week_id"
    t.integer "user_id"
    t.string  "name"
    t.string  "decsription"
    t.string  "state",         default: "do_not_use"
    t.integer "number_of_try"
    t.float   "score",         default: 0.0
    t.float   "score_limit",   default: 0.0
  end

  create_table "rooms_learning_objects", force: :cascade do |t|
    t.integer "room_id"
    t.integer "learning_object_id"
  end

  create_table "setups", force: :cascade do |t|
    t.string   "name"
    t.datetime "first_week_at"
    t.integer  "week_count"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "course_id",                     null: false
    t.boolean  "show_all",      default: false
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
    t.integer  "user_id",                                    null: false
    t.integer  "learning_object_id",                         null: false
    t.integer  "setup_id",                                   null: false
    t.string   "type"
    t.string   "interaction"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "activity_recommender_check", default: false
    t.integer  "room_id"
    t.integer  "number_of_try"
  end

  create_table "users", force: :cascade do |t|
    t.string   "login"
    t.string   "aisid"
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",       default: 0,         null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "remember_token"
    t.string   "role",                default: "student", null: false
    t.string   "encrypted_password",  default: "",        null: false
    t.string   "type",                default: "",        null: false
    t.boolean  "show_solutions",      default: false
    t.string   "email"
    t.string   "ais_email"
    t.string   "group",               default: "X"
    t.float    "proficiency",         default: 0.5
  end

  add_index "users", ["login"], name: "index_users_on_login", unique: true, using: :btree

  create_table "weeks", force: :cascade do |t|
    t.integer "setup_id"
    t.integer "number"
  end

  add_foreign_key "activity_recommender_records", "learning_objects"
  add_foreign_key "answers", "learning_objects"
  add_foreign_key "concepts", "courses"
  add_foreign_key "concepts_learning_objects", "concepts"
  add_foreign_key "concepts_learning_objects", "learning_objects"
  add_foreign_key "concepts_weeks", "concepts"
  add_foreign_key "concepts_weeks", "weeks"
  add_foreign_key "feedbacks", "learning_objects"
  add_foreign_key "feedbacks", "users"
  add_foreign_key "irt_values", "learning_objects"
  add_foreign_key "recommendation_linkers", "recommendation_configurations"
  add_foreign_key "recommendation_linkers", "users"
  add_foreign_key "recommendation_linkers", "weeks"
  add_foreign_key "recommenders_options", "recommendation_configurations"
  add_foreign_key "recommenders_options", "recommenders"
  add_foreign_key "rooms", "users"
  add_foreign_key "rooms", "weeks"
  add_foreign_key "rooms_learning_objects", "learning_objects"
  add_foreign_key "rooms_learning_objects", "rooms"
  add_foreign_key "setups", "courses"
  add_foreign_key "setups_users", "setups"
  add_foreign_key "setups_users", "users"
  add_foreign_key "user_to_lo_relations", "learning_objects"
  add_foreign_key "user_to_lo_relations", "rooms"
  add_foreign_key "user_to_lo_relations", "setups"
  add_foreign_key "user_to_lo_relations", "users"
  add_foreign_key "weeks", "setups"
end
