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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130513040649) do

  create_table "adoptions", :force => true do |t|
    t.string   "number"
    t.integer  "fee"
    t.string   "sales_type"
    t.string   "state",                   :default => "new"
    t.integer  "user_id"
    t.integer  "sales_event_id"
    t.integer  "club_id"
    t.integer  "payment_notification_id"
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.integer  "club_member_id"
  end

  create_table "club_members", :force => true do |t|
    t.string   "name"
    t.string   "picture_url"
    t.integer  "organization_id"
    t.string   "email"
    t.string   "encrypted_password",     :default => "",       :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string   "provider"
    t.string   "uid"
    t.string   "oauth_token"
    t.time     "oauth_expires_at"
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
    t.string   "role",                   :default => "member"
    t.boolean  "approved",               :default => false
    t.string   "title"
  end

  add_index "club_members", ["email"], :name => "index_club_members_on_email", :unique => true
  add_index "club_members", ["reset_password_token"], :name => "index_club_members_on_reset_password_token", :unique => true

  create_table "contact_infos", :force => true do |t|
    t.string   "full_name"
    t.string   "email"
    t.string   "phone"
    t.string   "city"
    t.string   "address"
    t.string   "state"
    t.string   "zip"
    t.string   "contact_type"
    t.integer  "contact_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "ducks", :force => true do |t|
    t.integer  "number"
    t.integer  "adoption_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "locations", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "omniauth_users", :force => true do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "oauth_token"
    t.string   "picture_url"
    t.time     "oauth_expires_at"
    t.integer  "organization_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "omniauth_users", ["organization_id"], :name => "index_omniauth_users_on_organization_id"

  create_table "organizations", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.string   "avatar"
    t.text     "description"
    t.boolean  "permit_members", :default => false
  end

  create_table "payment_notifications", :force => true do |t|
    t.string   "transaction_id"
    t.string   "invoice"
    t.string   "status"
    t.string   "state",          :default => "new"
    t.text     "params"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  create_table "pricings", :force => true do |t|
    t.decimal  "price"
    t.integer  "quantity"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "sales_events", :force => true do |t|
    t.date     "date"
    t.integer  "organization_id"
    t.integer  "location_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "settings", :force => true do |t|
    t.boolean "adoptions_live"
    t.integer "duck_inventory"
    t.string  "canned_site_message", :default => "member"
    t.text    "custom_site_message", :default => "member"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "role"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
