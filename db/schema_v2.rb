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

ActiveRecord::Schema.define(version: 2020_11_15_012105) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string "name", limit: 100, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ethnicities", force: :cascade do |t|
    t.string "name", limit: 100, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "images", force: :cascade do |t|
    t.bigint "recipe_id"
    t.text "filename", null: false
    t.index ["recipe_id"], name: "index_images_on_recipe_id"
  end

  create_table "ingredients", force: :cascade do |t|
    t.bigint "recipe_id"
    t.text "description", null: false
    t.index ["recipe_id"], name: "index_ingredients_on_recipe_id"
  end

  create_table "recipes", force: :cascade do |t|
    t.string "name", limit: 100, null: false
    t.text "description"
    t.interval "cook_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "note"
  end

  create_table "recipes_categories", force: :cascade do |t|
    t.bigint "recipe_id"
    t.bigint "category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_recipes_categories_on_category_id"
    t.index ["recipe_id"], name: "index_recipes_categories_on_recipe_id"
  end

  create_table "recipes_ethnicities", id: false, force: :cascade do |t|
    t.bigint "recipe_id", null: false
    t.bigint "ethnicity_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ethnicity_id"], name: "index_recipes_ethnicities_on_ethnicity_id"
    t.index ["recipe_id"], name: "index_recipes_ethnicities_on_recipe_id"
  end

  create_table "steps", force: :cascade do |t|
    t.bigint "recipe_id"
    t.string "description", limit: 100, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recipe_id"], name: "index_steps_on_recipe_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
