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

ActiveRecord::Schema.define(version: 20150212015057) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string   "username"
    t.string   "password_digest"
    t.string   "email"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "item_orders", force: :cascade do |t|
    t.integer  "item_id"
    t.integer  "order_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "items", force: :cascade do |t|
    t.string   "title"
    t.integer  "price"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.string   "description"
    t.boolean  "retired",               default: false
    t.integer  "tenant_id"
    t.date     "requested_by"
    t.date     "reqpayment_begin"
    t.integer  "repayment_rate"
  end

  add_index "items", ["tenant_id"], name: "index_items_on_tenant_id", using: :btree

  create_table "items_categories", force: :cascade do |t|
    t.integer  "item_id"
    t.integer  "category_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "orders", force: :cascade do |t|
    t.integer  "total_cost"
    t.integer  "user_id"
    t.string   "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "photos", force: :cascade do |t|
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "item_id"
  end

  add_index "photos", ["item_id"], name: "index_photos_on_item_id", using: :btree

  create_table "tenants", force: :cascade do |t|
    t.string   "location"
    t.string   "organization"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "password_digest"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "role",                           default: 0
    t.string   "credit_card_info"
    t.string   "street"
    t.string   "city"
    t.string   "state"
    t.string   "zipcode"
    t.string   "country"
    t.string   "credit_card_digest"
    t.integer  "tenant_id"
  end

  add_index "users", ["tenant_id"], name: "index_users_on_tenant_id", using: :btree

end
