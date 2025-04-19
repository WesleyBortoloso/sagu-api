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

ActiveRecord::Schema[7.1].define(version: 2025_04_18_205946) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "allowlisted_jwts", force: :cascade do |t|
    t.string "jti", null: false
    t.string "aud"
    t.datetime "exp", precision: nil, null: false
    t.uuid "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["jti"], name: "index_allowlisted_jwts_on_jti", unique: true
    t.index ["user_id"], name: "index_allowlisted_jwts_on_user_id"
  end

  create_table "authorizations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.date "date"
    t.string "description"
    t.string "status"
    t.uuid "student_id", null: false
    t.uuid "parent_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "classrooms", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "grade"
    t.date "year"
    t.integer "external_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "classrooms_teachers", id: false, force: :cascade do |t|
    t.uuid "classroom_id", null: false
    t.uuid "teacher_id", null: false
    t.index ["classroom_id", "teacher_id"], name: "index_classrooms_teachers_on_classroom_id_and_teacher_id", unique: true
  end

  create_table "documents", force: :cascade do |t|
    t.string "name"
    t.string "kind"
    t.uuid "student_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["student_id"], name: "index_documents_on_student_id"
  end

  create_table "events", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "description", null: false
    t.uuid "eventable_id", null: false
    t.string "eventable_type", null: false
    t.uuid "author_id", null: false
    t.string "author_type", null: false
    t.jsonb "metadata", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_events_on_author_type_and_author_id"
    t.index ["eventable_type", "eventable_id"], name: "index_events_on_eventable_type_and_eventable_id"
  end

  create_table "occurrencies", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "title", null: false
    t.string "description"
    t.string "kind", null: false
    t.string "severity", null: false
    t.string "status"
    t.string "priority"
    t.uuid "student_id", null: false
    t.uuid "relator_id", null: false
    t.uuid "responsible_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "orientations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.string "area"
    t.string "status"
    t.uuid "student_id", null: false
    t.uuid "parent_id", null: false
    t.uuid "relator_id", null: false
    t.uuid "responsible_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "schedules", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "starts_at", null: false
    t.string "subject"
    t.string "area"
    t.string "status"
    t.uuid "parent_id", null: false
    t.uuid "relator_id", null: false
    t.uuid "student_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "type"
    t.string "name", null: false
    t.string "document", null: false
    t.string "gender"
    t.date "birthdate"
    t.string "phone"
    t.integer "institutional_id"
    t.uuid "classroom_id"
    t.jsonb "extra_info", default: {}
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "parent_id"
    t.index ["classroom_id"], name: "index_users_on_classroom_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["parent_id"], name: "index_users_on_parent_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "allowlisted_jwts", "users", on_delete: :cascade
  add_foreign_key "authorizations", "users", column: "parent_id"
  add_foreign_key "authorizations", "users", column: "student_id"
  add_foreign_key "classrooms_teachers", "classrooms", on_delete: :cascade
  add_foreign_key "classrooms_teachers", "users", column: "teacher_id", on_delete: :cascade
  add_foreign_key "documents", "users", column: "student_id"
  add_foreign_key "occurrencies", "users", column: "relator_id"
  add_foreign_key "occurrencies", "users", column: "responsible_id"
  add_foreign_key "occurrencies", "users", column: "student_id"
  add_foreign_key "orientations", "users", column: "parent_id"
  add_foreign_key "orientations", "users", column: "relator_id"
  add_foreign_key "orientations", "users", column: "responsible_id"
  add_foreign_key "orientations", "users", column: "student_id"
  add_foreign_key "schedules", "users", column: "parent_id"
  add_foreign_key "schedules", "users", column: "relator_id"
  add_foreign_key "schedules", "users", column: "student_id"
  add_foreign_key "users", "users", column: "parent_id"
end
