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

ActiveRecord::Schema.define(version: 2021_12_04_053318) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "first_names", force: :cascade do |t|
    t.bigint "group_id", null: false
    t.string "name"
    t.string "reading"
    t.string "fotune_telling_url"
    t.integer "fotune_telling_rate"
    t.string "fotune_telling_image"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["group_id"], name: "index_first_names_on_group_id"
  end

  create_table "groups", force: :cascade do |t|
    t.string "last_name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
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
    t.index ["group_id"], name: "index_users_on_group_id"
  end

  add_foreign_key "first_names", "groups"
  add_foreign_key "rates", "first_names"
  add_foreign_key "rates", "users"
  add_foreign_key "users", "groups"
end
