# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_08_05_003228) do
  create_table "authors", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "additional_information"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "authors_entries", id: false, force: :cascade do |t|
    t.integer "entry_id", null: false
    t.integer "author_id", null: false
    t.index ["author_id", "entry_id"], name: "index_authors_entries_on_author_id_and_entry_id"
    t.index ["entry_id", "author_id"], name: "index_authors_entries_on_entry_id_and_author_id"
  end

  create_table "entries", force: :cascade do |t|
    t.text "full_title"
    t.datetime "publication_date"
    t.integer "start_page"
    t.integer "end_page"
    t.integer "start_folio"
    t.integer "end_folio"
    t.integer "type"
    t.string "isbn"
    t.string "isbn13"
    t.integer "format"
    t.string "language"
    t.string "publisher"
    t.string "file_location"
    t.integer "volume"
    t.string "series"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "start_side"
    t.string "end_side"
  end
end
