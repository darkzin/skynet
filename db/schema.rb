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

ActiveRecord::Schema.define(version: 20130729051321) do

  create_table "assignments", force: true do |t|
    t.string   "state"
    t.text     "compile_message"
    t.integer  "lead_time"
    t.integer  "memory_usage"
    t.integer  "student_id"
    t.integer  "problem_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "result"
  end

  add_index "assignments", ["problem_id"], name: "index_assignments_on_problem_id"
  add_index "assignments", ["student_id"], name: "index_assignments_on_student_id"

  create_table "courses", force: true do |t|
    t.text     "about"
    t.integer  "professor_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.integer  "year"
    t.integer  "term"
  end

  add_index "courses", ["professor_id"], name: "index_courses_on_professor_id"

  create_table "criterions", force: true do |t|
    t.string   "title"
    t.integer  "score"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "problem_id"
  end

  add_index "criterions", ["problem_id"], name: "index_criterions_on_problem_id"

  create_table "deadlines", force: true do |t|
    t.datetime "from"
    t.integer  "penalty"
    t.integer  "subject_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "to"
  end

  add_index "deadlines", ["subject_id"], name: "index_deadlines_on_subject_id"

  create_table "enrolls", force: true do |t|
    t.integer  "student_id"
    t.integer  "course_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "enrolls", ["course_id"], name: "index_enrolls_on_course_id"
  add_index "enrolls", ["student_id"], name: "index_enrolls_on_student_id"

  create_table "file_infos", force: true do |t|
    t.string   "name"
    t.string   "path"
    t.string   "extension"
    t.integer  "category_id"
    t.string   "category_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "file"
  end

  add_index "file_infos", ["category_id", "category_type"], name: "index_file_infos_on_category_id_and_category_type"

  create_table "notices", force: true do |t|
    t.text     "content"
    t.integer  "professor_id"
    t.integer  "course_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
  end

  add_index "notices", ["course_id"], name: "index_notices_on_course_id"
  add_index "notices", ["professor_id"], name: "index_notices_on_professor_id"

  create_table "problems", force: true do |t|
    t.string   "title"
    t.text     "about"
    t.integer  "order"
    t.text     "model_paper"
    t.text     "input_data"
    t.integer  "subject_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "problems", ["subject_id"], name: "index_problems_on_subject_id"

  create_table "professors", force: true do |t|
    t.string   "email",               default: "", null: false
    t.string   "encrypted_password",  default: "", null: false
    t.string   "name",                default: "", null: false
    t.string   "phone_number",        default: "", null: false
    t.string   "about"
    t.integer  "sign_in_count",       default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "failed_attempts",     default: 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "remember_created_at"
  end

  create_table "students", force: true do |t|
    t.string   "student_number",         default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "name"
    t.string   "phone_number"
    t.string   "email"
    t.text     "about"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "students", ["reset_password_token"], name: "index_students_on_reset_password_token", unique: true
  add_index "students", ["student_number"], name: "index_students_on_student_number", unique: true

  create_table "subjects", force: true do |t|
    t.string   "title"
    t.text     "about"
    t.integer  "order"
    t.integer  "course_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "subjects", ["course_id"], name: "index_subjects_on_course_id"

end
