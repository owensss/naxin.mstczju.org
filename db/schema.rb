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

ActiveRecord::Schema.define(:version => 20130911061756) do

  create_table "active_admin_comments", :force => true do |t|
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_admin_notes_on_admin_user_type_and_admin_user_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id", "namespace"], :name => "index_res_and_ns"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "forms", :force => true do |t|
    t.string   "name"
    t.string   "tel"
    t.string   "major"
    t.integer  "gender"
    t.string   "email"
    t.integer  "campus"
    t.string   "forum_id"
    t.integer  "groups"
    t.string   "cookie_hash"
    t.text     "comments"
    t.integer  "state"
    t.boolean  "spam",        :default => false, :null => false
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.string   "user_agent"
    t.text     "tg_q1"
    t.text     "tg_q2"
    t.text     "tg_q3"
    t.text     "tg_q4"
    t.text     "og_q1"
    t.text     "og_q2"
    t.text     "og_q3"
    t.text     "pg_q1"
    t.text     "pg_q2"
    t.text     "pg_q3"
    t.text     "cg_q1"
    t.text     "cg_q2"
    t.text     "cg_q3"
  end

  add_index "forms", ["spam", "id"], :name => "index_forms_on_spam_and_id"

  create_table "ftp_links", :force => true do |t|
    t.string   "name",                      :null => false
    t.string   "path",                      :null => false
    t.integer  "year",                      :null => false
    t.integer  "tags",       :default => 0, :null => false
    t.string   "note"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "staffs", :force => true do |t|
    t.string   "email",               :default => "", :null => false
    t.string   "nick",                :default => "", :null => false
    t.string   "name",                :default => "", :null => false
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
  end

  add_index "staffs", ["email"], :name => "index_staffs_on_email", :unique => true

end
