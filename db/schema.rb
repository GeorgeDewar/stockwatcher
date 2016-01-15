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

ActiveRecord::Schema.define(version: 20140207220937) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "alerts", force: :cascade do |t|
    t.integer  "watch_id"
    t.integer  "previous_quote_id"
    t.integer  "current_quote_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "alerts", ["watch_id"], name: "index_alerts_on_watch_id", using: :btree

  create_table "quotes", force: :cascade do |t|
    t.integer  "stock_id"
    t.decimal  "price"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "last_trade_time"
    t.decimal  "prev_close"
  end

  add_index "quotes", ["stock_id"], name: "index_quotes_on_stock_id", using: :btree

  create_table "stocks", force: :cascade do |t|
    t.string   "code",       limit: 3,  null: false
    t.string   "name",       limit: 50, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "stocks", ["code"], name: "index_stocks_on_code", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "watches", force: :cascade do |t|
    t.decimal  "threshold",  null: false
    t.integer  "user_id",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "stock_id",   null: false
  end

  add_index "watches", ["stock_id"], name: "index_watches_on_stock_id", using: :btree
  add_index "watches", ["user_id"], name: "index_watches_on_user_id", using: :btree

end
