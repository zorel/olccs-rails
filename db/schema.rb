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

ActiveRecord::Schema.define(:version => 20120731083222) do

  create_table "links", :force => true do |t|
    t.text     "href"
    t.text     "status"
    t.boolean  "indexed",    :default => false
    t.boolean  "previewed",  :default => false
    t.integer  "post_id"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "posts", :force => true do |t|
    t.integer "p_id"
    t.text    "login"
    t.text    "info"
    t.text    "time"
    t.text    "message"
    t.integer "tribune_id"
  end

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
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "users", :force => true do |t|
    t.text     "provider"
    t.text     "uid"
    t.text     "olcc_cookie"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

end
