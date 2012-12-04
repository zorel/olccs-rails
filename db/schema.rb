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

ActiveRecord::Schema.define(:version => 20121204085858) do

  create_table "links", :force => true do |t|
    t.text     "href"
    t.text     "status"
    t.boolean  "to_index",   :default => true
    t.boolean  "previewed",  :default => false
    t.boolean  "indexed",    :default => false
    t.integer  "post_id"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "links", ["post_id"], :name => "post_id_index"

  create_table "posts", :force => true do |t|
    t.integer "p_id"
    t.text    "login"
    t.text    "info"
    t.text    "time"
    t.text    "message"
    t.integer "tribune_id"
  end

  add_index "posts", ["p_id", "tribune_id"], :name => "pid_tribuneid_unique_index", :unique => true
  add_index "posts", ["p_id"], :name => "p_id_index"

  create_table "rules", :force => true do |t|
    t.text     "name"
    t.text     "filter"
    t.text     "action"
    t.text     "parameters"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "tribune_id"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "tribunes", :force => true do |t|
    t.text     "name"
    t.text     "get_url"
    t.text     "last_id_parameter"
    t.text     "post_parameter"
    t.text     "post_url"
    t.text     "cookie_url"
    t.text     "cookie_name"
    t.text     "user_parameter"
    t.text     "pwd_parameter"
    t.text     "remember_me_parameter"
    t.datetime "last_updated",          :default => '2012-09-17 11:52:47'
    t.integer  "refresh_interval",      :default => 15
    t.datetime "created_at",                                               :null => false
    t.datetime "updated_at",                                               :null => false
    t.integer  "type_slip"
  end

  create_table "users", :force => true do |t|
    t.text     "provider"
    t.text     "uid"
    t.text     "name"
    t.text     "olcc_cookie"
    t.boolean  "use_rules",   :default => false
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

end
