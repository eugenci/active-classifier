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

ActiveRecord::Schema.define(:version => 20130315083115) do

  create_table "device_attributes", :force => true do |t|
    t.integer  "class_id"
    t.string   "vendor"
    t.datetime "issued_at"
  end

  create_table "items", :force => true do |t|
    t.string   "name"
    t.string   "type"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "modem_attributes", :force => true do |t|
    t.integer "class_id"
    t.integer "num_of_ifs"
    t.integer "line",       :default => 1
  end

  create_table "telsey_attributes", :force => true do |t|
    t.integer "class_id"
    t.string  "mac"
  end

end
