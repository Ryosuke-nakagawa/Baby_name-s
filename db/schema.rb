# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_01_14_075821) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "first_names", force: :cascade do |t|
    t.bigint "group_id", null: false
    t.string "name", null: false
    t.string "reading"
    t.string "fotune_telling_url"
    t.integer "fotune_telling_rate"
    t.string "fotune_telling_image"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["group_id"], name: "index_first_names_on_group_id"
  end

  create_table "groups", force: :cascade do |t|
    t.string "last_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "likes", force: :cascade do |t|
    t.bigint "first_name_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["first_name_id", "user_id"], name: "index_likes_on_first_name_id_and_user_id", unique: true
    t.index ["first_name_id"], name: "index_likes_on_first_name_id"
    t.index ["user_id"], name: "index_likes_on_user_id"
  end

  create_table "rates", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "first_name_id", null: false
    t.integer "sound_rate"
    t.integer "character_rate"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["first_name_id"], name: "index_rates_on_first_name_id"
    t.index ["user_id"], name: "index_rates_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "uuid"
    t.string "line_id", null: false
    t.integer "sound_rate_setting"
    t.integer "character_rate_setting"
    t.integer "fotune_telling_rate_setting"
    t.bigint "group_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "status", default: 0, null: false
    t.bigint "editing_name_id"
    t.index ["editing_name_id"], name: "index_users_on_editing_name_id"
    t.index ["group_id"], name: "index_users_on_group_id"
    t.index ["line_id"], name: "index_users_on_line_id", unique: true
  end

  add_foreign_key "first_names", "groups"
  add_foreign_key "likes", "first_names"
  add_foreign_key "likes", "users"
  add_foreign_key "rates", "first_names"
  add_foreign_key "rates", "users"
  add_foreign_key "users", "first_names", column: "editing_name_id"
  add_foreign_key "users", "groups"
end
