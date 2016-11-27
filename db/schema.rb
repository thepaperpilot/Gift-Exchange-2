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

ActiveRecord::Schema.define(version: 20161008173359) do

  create_table "groups", force: :cascade do |t|
    t.string   "name"
    t.string   "code"
    t.string   "instructions",    default: "To join the group, type your name in the form below and click 'Join Group'. After the gift exchanges are generated you'll be able to look up who you are giving to and receiving from through this link. You can also share this link with others so they can join the group as well."
    t.string   "password_digest"
    t.boolean  "open",            default: true
    t.boolean  "public",          default: true
    t.datetime "created_at",                                                                                                                                                                                                                                                                                                        null: false
    t.datetime "updated_at",                                                                                                                                                                                                                                                                                                        null: false
  end

  create_table "people", force: :cascade do |t|
    t.string   "name"
    t.string   "family"
    t.boolean  "participating",  default: true
    t.integer  "giving_to"
    t.integer  "receiving_from"
    t.integer  "group_id"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.index ["group_id"], name: "index_people_on_group_id"
  end

  create_table "rules", force: :cascade do |t|
    t.string   "name",                default: "New Rule"
    t.boolean  "source_match_all"
    t.boolean  "whitelist_match_all"
    t.integer  "group_id"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.index ["group_id"], name: "index_rules_on_group_id"
  end

  create_table "tokens", force: :cascade do |t|
    t.string   "token"
    t.string   "type"
    t.boolean  "names",      default: true
    t.boolean  "groups"
    t.boolean  "case"
    t.boolean  "regex"
    t.boolean  "invert"
    t.integer  "rule_id"
    t.integer  "group_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.index ["group_id"], name: "index_tokens_on_group_id"
    t.index ["rule_id"], name: "index_tokens_on_rule_id"
  end

end
