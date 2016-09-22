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

ActiveRecord::Schema.define(version: 20150528223556) do

  create_table "adorns", force: true do |t|
    t.integer  "user_blog_id"
    t.integer  "user_item_id"
    t.integer  "user_outfit_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "authorizations", force: true do |t|
    t.string   "provider"
    t.string   "uid"
    t.integer  "user_id"
    t.string   "token"
    t.string   "secret"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "name"
    t.string   "link"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "basic_categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "basic_items", force: true do |t|
    t.string   "title"
    t.string   "description"
    t.string   "price"
    t.integer  "basic_subcategory_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "color"
  end

  create_table "basic_subcategories", force: true do |t|
    t.string   "name"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "basic_category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "brands", force: true do |t|
    t.string   "name"
    t.string   "pic_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
  end

  create_table "comments", force: true do |t|
    t.string   "text"
    t.integer  "user_blog_id"
    t.integer  "user_item_id"
    t.integer  "user_outfit_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fav_brands", force: true do |t|
    t.integer  "brand_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mentions", force: true do |t|
    t.string   "mention_type"
    t.integer  "by_user"
    t.boolean  "read_flag",      default: false
    t.integer  "user_id"
    t.integer  "user_blog_id"
    t.integer  "user_item_id"
    t.integer  "user_outfit_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "content_id"
    t.string   "content_type"
  end

  create_table "notification_settings", force: true do |t|
    t.boolean  "new_adoorns",            default: false
    t.boolean  "mentions",               default: false
    t.boolean  "item_adoorns",           default: false
    t.boolean  "outfit_adoorns",         default: false
    t.boolean  "special_offers",         default: false
    t.boolean  "editor_recommendations", default: false
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "outfit_items", force: true do |t|
    t.integer  "user_item_id"
    t.integer  "user_outfit_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "basic_item_id"
  end

  create_table "recent_searches", force: true do |t|
    t.string   "search"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "search_type"
  end

  create_table "reports", force: true do |t|
    t.string   "comment"
    t.integer  "by_user"
    t.integer  "user_blog_id"
    t.integer  "user_item_id"
    t.integer  "user_outfit_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_viewed"
  end

  create_table "role_users", force: true do |t|
    t.integer  "role_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", force: true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", force: true do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "user_adoorners", force: true do |t|
    t.integer  "adoorner_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_bloggers", force: true do |t|
    t.integer  "blogger_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_blogs", force: true do |t|
    t.string   "text"
    t.string   "pic_url"
    t.boolean  "private_flag",                          default: false
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_active",                             default: true
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "title"
    t.text     "content",            limit: 2147483647
    t.string   "identifier"
    t.string   "web_link"
  end

  create_table "user_feeds", force: true do |t|
    t.text     "url"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "is_active",  default: 2
    t.string   "feed_title"
  end

  add_index "user_feeds", ["user_id"], name: "index_user_feeds_on_user_id", using: :btree

  create_table "user_items", force: true do |t|
    t.string   "title"
    t.string   "description"
    t.string   "pic_url"
    t.boolean  "private_flag",       default: false
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_active",          default: true
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.float    "price"
    t.string   "buy_link"
  end

  create_table "user_outfits", force: true do |t|
    t.string   "title"
    t.string   "description"
    t.string   "pic_url"
    t.boolean  "private_flag",       default: false
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.boolean  "is_active"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: ""
    t.string   "encrypted_password",     default: "",    null: false
    t.text     "first_name"
    t.string   "last_name"
    t.string   "user_name"
    t.string   "location"
    t.string   "pic_url"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "about_me"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "isactive",               default: true
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "provider"
    t.string   "uid"
    t.boolean  "is_featured",            default: false
    t.boolean  "hide_as_user",           default: false
  end

end
