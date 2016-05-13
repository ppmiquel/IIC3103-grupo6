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

ActiveRecord::Schema.define(version: 20160513134712) do

  create_table "facturas", force: :cascade do |t|
    t.string   "idfact"
    t.string   "cliente"
    t.string   "proveedor"
    t.integer  "valor_bruto"
    t.integer  "iva"
    t.string   "estado"
    t.string   "idoc"
    t.string   "idtrx"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "groups", force: :cascade do |t|
    t.string   "idgrupo"
    t.integer  "numero"
    t.string   "cuenta"
    t.boolean  "importa"
    t.string   "sku1"
    t.string   "sku2"
    t.string   "sku3"
    t.string   "sku4"
    t.string   "sku5"
    t.string   "sku6"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "warehouse"
  end

  create_table "ordens", force: :cascade do |t|
    t.string   "idoc"
    t.string   "canal"
    t.string   "cliente"
    t.string   "sku"
    t.integer  "cantidad"
    t.integer  "precio"
    t.integer  "fecha_entrega"
    t.string   "idtrx"
    t.string   "idfact"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "transactions", force: :cascade do |t|
    t.string   "idtrx"
    t.integer  "monto"
    t.string   "cuenta_o"
    t.string   "cuenta_d"
    t.string   "grupo_o"
    t.string   "grupo_d"
    t.boolean  "usada"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
