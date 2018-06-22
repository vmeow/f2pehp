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

ActiveRecord::Schema.define(version: 20180622013652) do

  create_table "items", force: :cascade do |t|
    t.string   "name"
    t.integer  "itemid"
    t.string   "icon"
    t.integer  "alch"
    t.integer  "current"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "players", force: :cascade do |t|
    t.string  "player_name"
    t.string  "player_acc_type"
    t.integer "overall_xp"
    t.integer "overall_lvl"
    t.float   "overall_ehp"
    t.integer "attack_xp"
    t.integer "attack_lvl"
    t.float   "attack_ehp"
    t.integer "defence_xp"
    t.integer "defence_lvl"
    t.float   "defence_ehp"
    t.integer "strength_xp"
    t.integer "strength_lvl"
    t.float   "strength_ehp"
    t.integer "hitpoints_xp"
    t.integer "hitpoints_lvl"
    t.float   "hitpoints_ehp"
    t.integer "ranged_xp"
    t.integer "ranged_lvl"
    t.float   "ranged_ehp"
    t.integer "prayer_xp"
    t.integer "prayer_lvl"
    t.float   "prayer_ehp"
    t.integer "magic_xp"
    t.integer "magic_lvl"
    t.float   "magic_ehp"
    t.integer "cooking_xp"
    t.integer "cooking_lvl"
    t.float   "cooking_ehp"
    t.integer "woodcutting_xp"
    t.integer "woodcutting_lvl"
    t.float   "woodcutting_ehp"
    t.integer "fishing_xp"
    t.integer "fishing_lvl"
    t.float   "fishing_ehp"
    t.integer "firemaking_xp"
    t.integer "firemaking_lvl"
    t.float   "firemaking_ehp"
    t.integer "crafting_xp"
    t.integer "crafting_lvl"
    t.float   "crafting_ehp"
    t.integer "smithing_xp"
    t.integer "smithing_lvl"
    t.float   "smithing_ehp"
    t.integer "mining_xp"
    t.integer "mining_lvl"
    t.float   "mining_ehp"
    t.integer "runecraft_xp"
    t.integer "runecraft_lvl"
    t.float   "runecraft_ehp"
    t.string  "filter_acc"
    t.string  "sort_skill"
    t.string  "potential_p2p"
    t.string  "slug"
    t.integer "overall_rank"
    t.integer "attack_rank"
    t.integer "defence_rank"
    t.integer "strength_rank"
    t.integer "hitpoints_rank"
    t.integer "ranged_rank"
    t.integer "prayer_rank"
    t.integer "magic_rank"
    t.integer "cooking_rank"
    t.integer "woodcutting_rank"
    t.integer "fishing_rank"
    t.integer "firemaking_rank"
    t.integer "crafting_rank"
    t.integer "smithing_rank"
    t.integer "mining_rank"
    t.integer "runecraft_rank"
    t.float   "overall_ehp_start"
    t.float   "overall_ehp_end"
    t.float   "mining_ehp_start"
    t.float   "mining_ehp_end"
    t.float   "fishing_ehp_start"
    t.float   "fishing_ehp_end"
    t.float   "woodcutting_ehp_start"
    t.float   "woodcutting_ehp_end"
    t.float   "firemaking_ehp_start"
    t.float   "firemaking_ehp_end"
    t.float   "cooking_ehp_start"
    t.float   "cooking_ehp_end"
    t.float   "combat_lvl"
  end

  create_table "settings", force: :cascade do |t|
    t.string   "var",                   null: false
    t.text     "value"
    t.integer  "thing_id"
    t.string   "thing_type", limit: 30
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "settings", ["thing_type", "thing_id", "var"], name: "index_settings_on_thing_type_and_thing_id_and_var", unique: true

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "pass"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
