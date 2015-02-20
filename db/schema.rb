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

ActiveRecord::Schema.define(version: 20150220083230) do

  create_table "addresses", force: :cascade do |t|
    t.integer  "user_id",           limit: 4
    t.string   "last_name",         limit: 255
    t.string   "first_name",        limit: 255
    t.string   "address",           limit: 255
    t.string   "city",              limit: 255
    t.string   "zipcode",           limit: 255
    t.string   "phone",             limit: 255
    t.string   "alternative_phone", limit: 255
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  add_index "addresses", ["user_id"], name: "index_addresses_on_user_id", using: :btree

  create_table "bills", force: :cascade do |t|
    t.integer  "single_order_detail_id", limit: 4
    t.integer  "address_id",             limit: 4
    t.integer  "item_total",             limit: 4
    t.integer  "total",                  limit: 4
    t.integer  "shipment_total",         limit: 4
    t.integer  "additional_tax_total",   limit: 4
    t.integer  "used_point",             limit: 4
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  add_index "bills", ["address_id"], name: "index_bills_on_address_id", using: :btree

  create_table "bills_payments", force: :cascade do |t|
    t.integer  "bill_id",    limit: 4
    t.integer  "payment_id", limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "bills_payments", ["bill_id"], name: "index_bills_payments_on_bill_id", using: :btree
  add_index "bills_payments", ["payment_id"], name: "index_bills_payments_on_payment_id", using: :btree

  create_table "payment_methods", force: :cascade do |t|
    t.string   "name",          limit: 255
    t.text     "description",   limit: 65535
    t.string   "environment",   limit: 255
    t.datetime "is_valid_at"
    t.datetime "is_invalid_at"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "payments", force: :cascade do |t|
    t.integer  "amount",            limit: 4
    t.integer  "used_point",        limit: 4
    t.integer  "payment_method_id", limit: 4
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "prices", force: :cascade do |t|
    t.integer  "variant_id", limit: 4
    t.integer  "amount",     limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "prices", ["variant_id"], name: "index_prices_on_variant_id", using: :btree

  create_table "products", force: :cascade do |t|
    t.string   "name",          limit: 255
    t.text     "description",   limit: 65535
    t.datetime "is_valid_at"
    t.datetime "is_invalid_at"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "products_taxons", force: :cascade do |t|
    t.integer  "product_id", limit: 4
    t.integer  "taxon_id",   limit: 4
    t.integer  "position",   limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "products_taxons", ["product_id"], name: "index_products_taxons_on_product_id", using: :btree

  create_table "profiles", force: :cascade do |t|
    t.string   "last_name",       limit: 255
    t.string   "first_name",      limit: 255
    t.string   "last_name_kana",  limit: 255
    t.string   "first_name_kana", limit: 255
    t.integer  "user_id",         limit: 4
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "profiles", ["user_id"], name: "index_profiles_on_user_id", using: :btree

  create_table "purchase_orders", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.integer  "state",      limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "purchase_orders", ["user_id"], name: "index_purchase_orders_on_user_id", using: :btree

  create_table "single_line_items", force: :cascade do |t|
    t.integer  "variant_id",             limit: 4
    t.integer  "single_order_detail_id", limit: 4
    t.integer  "quantity",               limit: 4
    t.integer  "price",                  limit: 4
    t.integer  "tax_rate_id",            limit: 4
    t.integer  "additional_tax_total",   limit: 4
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  add_index "single_line_items", ["single_order_detail_id"], name: "index_single_line_items_on_single_order_detail_id", using: :btree
  add_index "single_line_items", ["variant_id"], name: "index_single_line_items_on_variant_id", using: :btree

  create_table "single_order_details", force: :cascade do |t|
    t.integer  "single_order_id",      limit: 4
    t.string   "number",               limit: 255
    t.integer  "item_total",           limit: 4
    t.integer  "total",                limit: 4
    t.datetime "completed_at"
    t.integer  "address_id",           limit: 4
    t.integer  "shipment_total",       limit: 4
    t.integer  "additional_tax_total", limit: 4
    t.integer  "adjustment_total",     limit: 4
    t.integer  "item_count",           limit: 4
    t.date     "date"
    t.integer  "lock_version",         limit: 4
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  add_index "single_order_details", ["address_id"], name: "index_single_order_details_on_address_id", using: :btree
  add_index "single_order_details", ["single_order_id"], name: "index_single_order_details_on_single_order_id", using: :btree

  create_table "single_orders", force: :cascade do |t|
    t.integer  "purchase_order_id", limit: 4
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "single_orders", ["purchase_order_id"], name: "index_single_orders_on_purchase_order_id", using: :btree

  create_table "subscription_line_items", force: :cascade do |t|
    t.integer  "variant_id",                   limit: 4
    t.integer  "subscription_order_detail_id", limit: 4
    t.integer  "quantity",                     limit: 4
    t.integer  "price",                        limit: 4
    t.integer  "tax_rate_id",                  limit: 4
    t.integer  "additional_tax_total",         limit: 4
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  add_index "subscription_line_items", ["subscription_order_detail_id"], name: "index_subscription_line_items_on_subscription_order_detail_id", using: :btree
  add_index "subscription_line_items", ["variant_id"], name: "index_subscription_line_items_on_variant_id", using: :btree

  create_table "subscription_order_details", force: :cascade do |t|
    t.integer  "subscription_order_id",  limit: 4
    t.string   "number",                 limit: 255
    t.integer  "item_total",             limit: 4
    t.integer  "total",                  limit: 4
    t.datetime "completed_at"
    t.integer  "address_id",             limit: 4
    t.integer  "shipment_total",         limit: 4
    t.integer  "additional_tax_total",   limit: 4
    t.boolean  "confirmation_delivered", limit: 1
    t.string   "guest_token",            limit: 255
    t.integer  "adjustment_total",       limit: 4
    t.integer  "item_count",             limit: 4
    t.date     "date"
    t.integer  "lock_version",           limit: 4
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  add_index "subscription_order_details", ["address_id"], name: "index_subscription_order_details_on_address_id", using: :btree
  add_index "subscription_order_details", ["subscription_order_id"], name: "index_subscription_order_details_on_subscription_order_id", using: :btree

  create_table "subscription_orders", force: :cascade do |t|
    t.integer  "purchase_order_id", limit: 4
    t.integer  "variant_id",        limit: 4
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "subscription_orders", ["purchase_order_id"], name: "index_subscription_orders_on_purchase_order_id", using: :btree
  add_index "subscription_orders", ["variant_id"], name: "index_subscription_orders_on_variant_id", using: :btree

  create_table "subscription_terms", force: :cascade do |t|
    t.integer  "subscription_order_id", limit: 4
    t.integer  "term",                  limit: 4
    t.integer  "interval",              limit: 4
    t.integer  "interval_unit",         limit: 4
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "subscription_terms", ["subscription_order_id"], name: "index_subscription_terms_on_subscription_order_id", using: :btree

  create_table "tax_rates", force: :cascade do |t|
    t.decimal  "amount",        precision: 10
    t.datetime "is_valid_at"
    t.datetime "is_invalid_at"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  create_table "taxonomies", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "position",   limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "taxons", force: :cascade do |t|
    t.integer  "parent_id",   limit: 4
    t.integer  "positon",     limit: 4
    t.string   "name",        limit: 255
    t.string   "permalink",   limit: 255
    t.integer  "taxonomy_id", limit: 4
    t.text     "description", limit: 65535
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "users", force: :cascade do |t|
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
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "variants", force: :cascade do |t|
    t.string   "sku",           limit: 255
    t.integer  "product_id",    limit: 4
    t.datetime "is_valid_at"
    t.datetime "is_invalid_at"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "variants", ["product_id"], name: "index_variants_on_product_id", using: :btree

  add_foreign_key "addresses", "users"
  add_foreign_key "bills", "addresses"
  add_foreign_key "bills_payments", "bills"
  add_foreign_key "bills_payments", "payments"
  add_foreign_key "prices", "variants"
  add_foreign_key "products_taxons", "products"
  add_foreign_key "profiles", "users"
  add_foreign_key "purchase_orders", "users"
  add_foreign_key "single_line_items", "single_order_details"
  add_foreign_key "single_line_items", "variants"
  add_foreign_key "single_order_details", "addresses"
  add_foreign_key "single_order_details", "single_orders"
  add_foreign_key "single_orders", "purchase_orders"
  add_foreign_key "subscription_line_items", "subscription_order_details"
  add_foreign_key "subscription_line_items", "variants"
  add_foreign_key "subscription_order_details", "addresses"
  add_foreign_key "subscription_order_details", "subscription_orders"
  add_foreign_key "subscription_orders", "purchase_orders"
  add_foreign_key "subscription_orders", "variants"
  add_foreign_key "subscription_terms", "subscription_orders"
  add_foreign_key "variants", "products"
end
