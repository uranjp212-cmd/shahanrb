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

ActiveRecord::Schema[8.1].define(version: 0) do
  create_table "f_gtutatsu", primary_key: "tutatuno", id: { limit: 6, precision: 6, default: 0 }, comment: "業務通達", force: :cascade do |t|
    t.integer "sday", limit: 8, precision: 8, default: 0
    t.integer "eday", limit: 8, precision: 8, default: 0
    t.string "secgroup", limit: 200, default: " "
    t.string "shainno", limit: 400, default: " "
    t.string "msgtitle", limit: 200, default: " "
    t.string "msgara", limit: 3000, default: " "
    t.boolean "endflg", default: false
    t.index ["endflg"], name: "f_gtutatsu_idx1", tablespace: "dev_tbs"
  end

  create_table "m_common", primary_key: ["reckbn", "key", "subkey"], comment: "CHOTTO MAX COMMON MASTER TABLE", force: :cascade do |t|
    t.string "reckbn", limit: 6, null: false
    t.integer "key", limit: 6, precision: 6, default: 0, null: false
    t.string "subkey", limit: 6, default: "1", null: false
    t.string "body", limit: 500, default: " "
    t.string "biko", limit: 500, default: " "
    t.boolean "delflg", default: false
  end

  create_table "m_module", primary_key: ["gmenucd", "moduleid"], comment: "CHOTTO MAX MODULE MASTER TABLE", force: :cascade do |t|
    t.integer "gmenucd", limit: 2, precision: 2, default: 0, null: false
    t.integer "moduleid", limit: 2, precision: 2, default: 0, null: false
    t.string "gmenumei", limit: 50
    t.string "gformmei", limit: 100
    t.boolean "aptype", default: false
    t.boolean "delflg", default: false
  end

  create_table "m_seckanri", primary_key: ["secgroup", "seclevel", "gmenucd"], comment: "CHOTTO MAX SECURITY MASTER TABLE", force: :cascade do |t|
    t.string "secgroup", limit: 3, null: false
    t.string "seclevel", limit: 3, null: false
    t.integer "gmenucd", limit: 2, precision: 2, default: 0, null: false
    t.string "moduleid", limit: 150
    t.boolean "delflg", default: false
  end

  create_table "m_smenu", primary_key: ["shaincd", "gmenucd"], comment: "CHOTTO MAX SHAIN SECURITY MASTER TABLE", force: :cascade do |t|
    t.integer "shaincd", limit: 6, precision: 6, default: 0, null: false
    t.string "gmenucd", limit: 3, null: false
    t.string "moduleid", limit: 150
    t.boolean "delflg", default: false
  end

  create_table "t_connectlog", id: false, force: :cascade do |t|
    t.string "ip", limit: 15
    t.string "hostname", limit: 50
    t.string "pgname", limit: 100
    t.integer "startbi", limit: 8, precision: 8, default: 0
    t.string "starttime", limit: 8
    t.integer "shaincd", limit: 6, precision: 6, default: 0
    t.string "shainmei", limit: 50
    t.integer "loginbi", limit: 8, precision: 8, default: 0
    t.string "logintime", limit: 8
    t.integer "logoutbi", limit: 8, precision: 8, default: 0
    t.string "logouttime", limit: 8
    t.index ["hostname", "loginbi"], name: "t_connectlog_idx3", tablespace: "dev_tbs"
    t.index ["ip", "hostname", "pgname", "startbi", "starttime"], name: "t_connectlog_idx1", tablespace: "dev_tbs"
    t.index ["ip", "loginbi"], name: "t_connectlog_idx2", tablespace: "dev_tbs"
  end

  create_table "t_hokokuruiseki", primary_key: ["kyakuno", "juchuno", "juchugyo"], force: :cascade do |t|
    t.integer "kyakuno", limit: 9, precision: 9, null: false
    t.integer "juchuno", limit: 4, precision: 4, null: false
    t.integer "juchugyo", limit: 2, precision: 2, null: false
    t.integer "baitaymd", limit: 8, precision: 8
    t.integer "jucukebi", limit: 8, precision: 8
    t.integer "juctrkbi", limit: 8, precision: 8
    t.string "jucdtlsts", limit: 2
    t.string "baitaikbn", limit: 3
    t.string "bumon", limit: 3
    t.integer "bango", limit: 6, precision: 6
    t.string "baitaimeir", limit: 20
    t.string "banku", limit: 2
    t.string "hinban", limit: 6
    t.string "colorcd", limit: 3
    t.string "sizecd", limit: 4
    t.integer "juchusu", limit: 12, precision: 12
    t.integer "juchugak", limit: 12, precision: 12
    t.date "koshinbi"
    t.integer "koshinshacd", limit: 6, precision: 6
    t.string "koshinprog", limit: 20
    t.index ["baitaymd", "jucukebi", "juctrkbi", "koshinbi"], name: "t_hokokuruiseki_idx3"
    t.index ["hinban", "colorcd", "sizecd"], name: "t_hokokuruiseki_idx2"
    t.index ["kyakuno", "juchuno", "juchugyo", "jucdtlsts"], name: "t_hokokuruiseki_idx1"
  end

  create_table "w_shahan_weborder_ctl", primary_key: ["shastabi", "shakbn"], comment: "社販サイト受注管理ファイル", force: :cascade do |t|
    t.integer "shastabi", limit: 8, precision: 8, default: 0, null: false, comment: "社販開始日"
    t.boolean "shakbn", default: false, null: false, comment: "社販区分"
    t.boolean "websts", default: false, comment: "社販サイト状態"
    t.integer "shaendbi", limit: 8, precision: 8, default: 0, comment: "社販終了日"
  end

  create_table "w_shahan_weborder_dlv", primary_key: ["shaincd", "delivno"], force: :cascade do |t|
    t.integer "shaincd", limit: 6, precision: 6, null: false
    t.integer "delivno", limit: 4, precision: 4, null: false
    t.string "delivmei", limit: 20
    t.string "ntelno", limit: 15
    t.string "zipno", limit: 7
    t.string "telno", limit: 15
    t.string "adr1", limit: 200
    t.decimal "delflg", default: "0.0"
    t.timestampltz "created_at", precision: 6
    t.timestampltz "updated_at", precision: 6
  end

  create_table "w_shahan_weborder_dtl", id: false, force: :cascade do |t|
    t.integer "shaincd", limit: 6, precision: 6
    t.integer "juchuno", limit: 4, precision: 4
    t.integer "juchugyo", limit: 2, precision: 2
    t.string "hinban", limit: 6
    t.string "colorcd", limit: 3, default: " "
    t.string "sizecd", limit: 4, default: " "
    t.integer "juchusu", limit: 4, precision: 4
    t.decimal "salebaika", default: "0.0"
    t.integer "kakuteisu", limit: 4, precision: 4
    t.timestampltz "created_at", precision: 6
    t.timestampltz "updated_at", precision: 6
    t.index ["shaincd", "juchuno", "juchugyo"], name: "w_shahan_order_dtl_test_pk", tablespace: "dev_tbs"
  end

  create_table "w_shahan_weborder_hdr", id: false, force: :cascade do |t|
    t.integer "shaincd", limit: 6, precision: 6
    t.integer "juchuno", limit: 4, precision: 4
    t.integer "delivno", limit: 4, precision: 4
    t.string "haisokbn", limit: 6
    t.string "juchustatus", limit: 6
    t.integer "dlvappbi", limit: 8, precision: 8
    t.string "dlvapptime", limit: 6
    t.string "dlvmemo", limit: 400
    t.integer "kakuteisu", limit: 4, precision: 4
    t.decimal "kakuteigak", precision: 9, scale: 2
    t.boolean "telflg"
    t.timestampltz "orderdate", precision: 6
    t.decimal "backup_id"
    t.timestampltz "created_at", precision: 6
    t.timestampltz "updated_at", precision: 6
    t.boolean "pickflg", default: false, comment: "抽出済みフラグ"
    t.integer "pickbi", limit: 8, precision: 8, default: 0, comment: "抽出日"
    t.integer "shastabi", limit: 8, precision: 8, default: 0, comment: "社販開始日"
    t.boolean "shakbn", default: false, comment: "社販区分"
    t.index ["shaincd", "juchuno"], name: "w_shahan_order_hdr_test_pk", tablespace: "dev_tbs"
  end

  create_table "w_shahan_weborder_lnk", primary_key: ["shaincd", "juchuno"], comment: "社販サイト受注関係ファイル", force: :cascade do |t|
    t.integer "shaincd", limit: 6, precision: 6, default: 0, null: false, comment: "社員番号"
    t.integer "juchuno", limit: 4, precision: 4, default: 0, null: false, comment: "受注番号"
    t.integer "delivno", limit: 4, precision: 4, default: 0, comment: "届け先番号"
    t.integer "kyakuno", limit: 9, precision: 9, default: 0, comment: "顧客番号"
    t.integer "juchushop", limit: 4, precision: 4, default: 0, comment: "受注番号SHOP"
    t.integer "delivshop", limit: 4, precision: 4, default: 0, comment: "届け先番号SHOP"
    t.integer "torokuunyobi", limit: 8, precision: 8, default: 0, comment: "登録運用日"
    t.date "torokubi", comment: "登録日時"
    t.boolean "okflg", default: false, comment: "確認ＦＬＧ"
    t.string "koshinprog", limit: 20, comment: "更新モジュール"
    t.date "koshinbi", comment: "更新日時"
  end

  create_table "w_shahan_weborder_setting", id: :decimal, comment: "冷凍社販サイトの本番ＤＢとして使用。2022/11/23 HC_FUJITA", force: :cascade do |t|
    t.date "reference"
    t.date "release"
    t.date "juchulimit"
    t.date "handover"
    t.date "delivery"
    t.date "sending"
    t.text "topcomment"
    t.timestampltz "created_at", precision: 6
    t.timestampltz "updated_at", precision: 6
  end

  create_table "w_shahandtl", primary_key: ["shaincd", "juchuno", "juchugyo"], comment: "社販受注明細ファイル", force: :cascade do |t|
    t.integer "shaincd", limit: 6, precision: 6, default: 0, null: false, comment: "社員コード"
    t.integer "juchuno", limit: 4, precision: 4, default: 0, null: false, comment: "受注番号"
    t.integer "juchugyo", limit: 2, precision: 2, default: 0, null: false, comment: "受注行番号"
    t.string "hinban", limit: 6, default: " ", comment: "品番"
    t.string "colorcd", limit: 3, default: " ", comment: "商品カラー"
    t.string "sizecd", limit: 4, default: " ", comment: "商品サイズ"
    t.integer "juchusu", limit: 4, precision: 4, default: 0, comment: "受注数"
    t.integer "baika", limit: 7, precision: 7, default: 0, comment: "税抜き売価"
    t.integer "juchugak", limit: 7, precision: 7, default: 0, comment: "受注額"
    t.integer "juchutax", limit: 7, precision: 7, default: 0, comment: "受注消費税"
    t.string "zeirtkbn", limit: 1, default: " ", comment: "消費税率区分"
    t.integer "zeirt", limit: 4, precision: 4, default: 0, comment: "消費税率"
    t.integer "kakuteisu", limit: 4, precision: 4, default: 0, comment: "確定数"
    t.timestampltz "created_at", precision: 6, comment: "登録日時"
    t.timestampltz "updated_at", precision: 6, comment: "更新日時"
  end

  create_table "w_shahanhdr", primary_key: ["shaincd", "juchuno"], comment: "社販受注ヘダファイル", force: :cascade do |t|
    t.integer "shaincd", limit: 6, precision: 6, default: 0, null: false, comment: "社員コード"
    t.integer "juchuno", limit: 4, precision: 4, default: 0, null: false, comment: "受注番号"
    t.string "juchdrsts", limit: 2, default: " ", comment: "受注ヘダー状態"
    t.string "shodelivkbn", limit: 1, default: " ", comment: "商品届先区分"
    t.integer "delivnoshop", limit: 4, precision: 4, default: 0, comment: "届先番号SHOP"
    t.integer "delivno", limit: 4, precision: 4, default: 0, comment: "届先番号"
    t.string "dlvkbn", limit: 2, default: " ", comment: "配送区分"
    t.integer "dlvappbi", limit: 8, precision: 8, default: 0, comment: "配送指定日"
    t.string "dlvapptime", limit: 1, default: " ", comment: "配送指定時間"
    t.string "dlvmemo", limit: 40, comment: "配送コメント"
    t.boolean "pickflg", default: false, comment: "抽出済みフラグ"
    t.integer "pickbi", limit: 8, precision: 8, default: 0, comment: "抽出日"
    t.integer "shastabi", limit: 8, precision: 8, default: 0, comment: "社販開始日"
    t.boolean "shakbn", default: false, comment: "社販区分"
    t.string "adrcd1", limit: 2, default: " ", comment: "住所コード（都道府県）新規届先"
    t.string "adrcd2", limit: 3, default: " ", comment: "住所コード（市区町村）"
    t.string "adrcd3", limit: 3, default: " ", comment: "住所コード（大字・通称）"
    t.string "adrcd4", limit: 3, default: " ", comment: "住所コード（字・丁目）"
    t.string "adr2", limit: 80, comment: "住所２"
    t.timestampltz "created_at", precision: 6, comment: "登録日時"
    t.timestampltz "updated_at", precision: 6, comment: "更新日時"
  end

  add_synonym "f_batchctl", "test003.f_batchctl", force: true
  add_synonym "f_juchudtl", "test003.f_juchudtl", force: true
  add_synonym "f_juchuhdr", "test003.f_juchuhdr", force: true
  add_synonym "f_webjuchdr", "test003.f_webjuchdr", force: true
  add_synonym "f_webjuchuctl", "test003.f_webjuchuctl", force: true
  add_synonym "m_codemei", "test003.m_codemei", force: true
  add_synonym "m_control", "test003.m_control", force: true
  add_synonym "m_floor", "test003.m_floor", force: true
  add_synonym "m_kokyaku", "test003.m_kokyaku", force: true
  add_synonym "m_modulekanri", "test003.m_modulekanri", force: true
  add_synonym "m_secgroup", "test003.m_secgroup", force: true
  add_synonym "m_seclevel", "test003.m_seclevel", force: true
  add_synonym "m_shain", "test003.m_shain", force: true
  add_synonym "m_shohin", "test003.m_shohin", force: true
  add_synonym "m_station", "test003.m_station", force: true
  add_synonym "m_todokesaki", "test003.m_todokesaki", force: true
  add_synonym "seq_batchproc", "test003.seq_batchproc", force: true
  add_synonym "sf_rito", "test003.sf_rito", force: true
  add_synonym "sp_log", "test003.sp_log", force: true
  add_synonym "v_webshahan", "test003.v_webshahan", force: true

end
