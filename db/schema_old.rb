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

ActiveRecord::Schema.define(version: 2020_11_13_013318) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", id: :serial, force: :cascade do |t|
    t.string "name", limit: 100, null: false
    t.index ["name"], name: "category_name_key", unique: true
  end

  create_table "ethnicities", id: :serial, force: :cascade do |t|
    t.string "name", limit: 100, null: false
    t.index ["name"], name: "ethnicity_name_key", unique: true
  end

  create_table "images", primary_key: ["recipe_id", "img_number"], force: :cascade do |t|
    t.integer "recipe_id", null: false
    t.integer "img_number", null: false
    t.text "img_filename", null: false
  end

  create_table "ingredients", primary_key: ["recipe_id", "ing_number"], force: :cascade do |t|
    t.integer "recipe_id", null: false
    t.integer "ing_number", null: false
    t.text "description", null: false
    t.boolean "complete", default: false
  end

  create_table "notes", primary_key: ["recipe_id", "note_number"], force: :cascade do |t|
    t.integer "recipe_id", null: false
    t.integer "note_number", null: false
    t.text "description", null: false
  end

  create_table "recipes", id: :serial, force: :cascade do |t|
    t.string "name", limit: 100, null: false
    t.text "description"
    t.interval "cook_time"
  end

  create_table "recipes_categories", primary_key: ["recipe_id", "category_id"], force: :cascade do |t|
    t.integer "recipe_id", null: false
    t.integer "category_id", null: false
  end

  create_table "recipes_ethnicities", primary_key: ["recipe_id", "ethnicity_id"], force: :cascade do |t|
    t.integer "recipe_id", null: false
    t.integer "ethnicity_id", null: false
  end

  create_table "steps", primary_key: ["recipe_id", "step_number"], force: :cascade do |t|
    t.integer "recipe_id", null: false
    t.integer "step_number", null: false
    t.text "description", null: false
    t.boolean "complete", default: false
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "images", "recipes", name: "images_recipe_id_fkey", on_delete: :cascade
  add_foreign_key "ingredients", "recipes", name: "ingredients_recipe_id_fkey", on_delete: :cascade
  add_foreign_key "notes", "recipes", name: "notes_recipes_id_fkey", on_delete: :cascade
  add_foreign_key "recipes_categories", "categories", name: "recipes_categories_category_id_fkey", on_delete: :cascade
  add_foreign_key "recipes_categories", "recipes", name: "recipes_categories_recipe_id_fkey", on_delete: :cascade
  add_foreign_key "recipes_ethnicities", "ethnicities", name: "recipes_ethnicities_ethnicity_id_fkey", on_delete: :cascade
  add_foreign_key "recipes_ethnicities", "recipes", name: "recipes_ethnicities_recipe_id_fkey", on_delete: :cascade
  add_foreign_key "steps", "recipes", name: "steps_recipes_id_fkey", on_delete: :cascade
end
