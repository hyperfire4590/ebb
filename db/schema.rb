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

ActiveRecord::Schema.define(:version => 20121116142714) do

  create_table "advertisements", :force => true do |t|
    t.integer  "user_id"
    t.integer  "board_id"
    t.integer  "width"
    t.integer  "height"
    t.binary   "image"
    t.integer  "x_location"
    t.integer  "y_location"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "boards", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.integer  "width"
    t.integer  "height"
    t.string   "timezone"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "payment_details", :force => true do |t|
    t.integer  "user_id"
    t.decimal  "amount"
    t.integer  "payable_id"
    t.integer  "payable_type"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "tiles", :force => true do |t|
    t.integer  "board_id"
    t.integer  "advertisement_id"
    t.integer  "x_location"
    t.integer  "y_location"
    t.decimal  "cost"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.boolean  "admin"
    t.string   "remember_token"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

end
