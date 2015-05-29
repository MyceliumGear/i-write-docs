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

ActiveRecord::Schema.define(version: 20150528123056) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "gateways", force: :cascade do |t|
    t.integer  "confirmations_required",      default: 0,     null: false
    t.string   "pubkey",                                      null: false
    t.string   "name",                                        null: false
    t.string   "default_currency",            default: "BTC", null: false
    t.string   "callback_url"
    t.boolean  "check_signature",             default: true,  null: false
    t.boolean  "active",                      default: true,  null: false
    t.string   "exchange_rate_adapter_names"
    t.integer  "user_id"
    t.integer  "straight_gateway_id"
    t.boolean  "deleted",                     default: false, null: false
    t.text     "description"
    t.string   "merchant_url"
    t.string   "country"
    t.string   "region"
    t.string   "city"
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.integer  "orders_expiration_period",    default: 900,   null: false
    t.string   "site_type"
    t.string   "straight_gateway_hashed_id"
  end

  add_index "gateways", ["user_id"], name: "index_gateways_on_user_id", using: :btree

  create_table "update_items", force: :cascade do |t|
    t.integer  "priority",   default: 0
    t.text     "subject"
    t.text     "body"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.integer  "role",                             default: 0
    t.string   "email",                                          null: false
    t.string   "encrypted_password",                             null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                    default: 0,   null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",                  default: 0,   null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "gauth_secret"
    t.string   "gauth_enabled",                    default: "f"
    t.string   "gauth_tmp"
    t.datetime "gauth_tmp_datetime"
    t.integer  "last_read_update_id"
    t.integer  "updates_email_subscription_level"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree
  add_index "users", ["updates_email_subscription_level"], name: "index_users_on_updates_email_subscription_level", using: :btree

  create_table "widget_products", force: :cascade do |t|
    t.integer  "widget_id"
    t.string   "title"
    t.float    "price"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.boolean  "singular",   default: true, null: false
  end

  add_index "widget_products", ["widget_id"], name: "index_widget_products_on_widget_id", using: :btree

  create_table "widgets", force: :cascade do |t|
    t.integer  "gateway_id"
    t.text     "fields"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "widgets", ["gateway_id"], name: "index_widgets_on_gateway_id", unique: true, using: :btree

end
