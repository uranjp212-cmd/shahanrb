class SaleController < ApplicationController
  before_action :require_shain_login # 社員ログイン必須チェック
  # index と create の両方で @tax_rate_map を事前に生成する
  before_action :set_tax_rate_map, only: [ :index, :create, :delivery_input ]
  before_action :load_dlvkbn_options, only: [ :new, :edit, :create ]
  SHAKBN = 3

  # コード名称マスタ（codekbn = 307）から配送時間の候補を取得
  def load_dlvkbn_options
    @dlvkbn_options = Ff2::Codemei.where(codekbn: "307").order(:codekey).map { |c| [ c.codemeir, c.codekey[0, 2] ] }
  end

  # # ストロングパラメータに dlvkbn を追加
  # def sale_params
  #   params.require(:sale).permit(:receipt_type, :dlvkbn, items: [:hinban, :suuryou]) # 実際のカラム構造に合わせて調整
  # end
  # def set_dlvkbn
  #   @dlbkbn_table = Ff2::Codemei.where(codekbn: "307").order(:codekey).map do |m|
  #     {
  #       dlvkbn: m.codekey[0, 2],
  #       dlvname: m.codemeir
  #     }
  #   end
  # end

  def index
    session.delete(:sale_draft)
    p "index in"
    # 一覧表示用のデータを取得
    load_existing_orders

    if @existing_orders.present?
      @is_edit = true
      p "size=" + @existing_orders.size.to_s
      order = @existing_orders[0]
      p "juchuno=" + order[:juchuno].to_s
    else
      # 受注画面へリダイレクト
      redirect_to new_sale_path and return
    end
  rescue => e
    Rails.logger.debug("【DEBUG】rescueにキャッチされました: #{e.message}")
    # その他例外時
    # flash.now[:alert] = "システムエラーが発生しました。登録をやり直してください。"
    flash.now[:alert] = e.message
    render :index, status: :unprocessable_entity
  end
  def new
    # 一覧から来た場合はセッションにフラグを立てる
    if session[:back_to_index].present?
      p "session[:back_to_index]=" + session[:back_to_index].to_s
    else
      p "params[:from]=" + params[:from].to_s
      if params[:from] == "index"
        session[:back_to_index] = true
      else
        session[:back_to_index] = false # 直接アクセスなどの場合
      end
    end
    @is_edit = false
    # @receipt_type = "takeout"
    @shahanhdr = Mpls::Shahanhdr.new
    # 初期表示用に空行を3行用意
    @inputdtls = Array.new(3) {
        { item_cd: "",
          color: "カラー",      # ★ 送信された値を保持
          size: "サイズ",        # ★ 送信された値を保持
          colors: nil,    # ★ カラー選択肢群
          sizes: nil,      # ★ サイズ選択肢群
          quantity: 1,
          item_name: "",
          juchukomigak: 0,
          baika: 0,
          juchugak: 0,
          juchutax: 0,
          zeirtkbn: nil,
          subtotal: 0
          }
      }
    draft_data = (session[:sale_draft] || {}).with_indifferent_access
    @selected_delivery = draft_data[:delivery] || {}
    if draft_data[:items].present?
      @receipt_type = draft_data[:receipt_type]
      @inputdtls = draft_data[:items]
    end
  rescue => e
    Rails.logger.debug("【DEBUG】rescueにキャッチされました: #{e.message}")
    # その他例外時
    # flash.now[:alert] = "システムエラーが発生しました。登録をやり直してください。"
    flash.now[:alert] = e.message
    render :new, status: :unprocessable_entity
  end

  def destroy
    juchuno = params[:juchuno]
    shaincd = current_shain.shaincd

    # 該当する受注ヘッダーと明細を検索（社員コードと受注番号で特定）
    shahanhdr = Mpls::Shahanhdr.find_by(shaincd: shaincd, juchuno: juchuno)

    if shahanhdr
      # トランザクションを使ってヘッダーと明細を安全に削除
      ActiveRecord::Base.transaction do
        # Mpls::Shahanhdtl.where(shaincd: shaincd, juchuno: juchuno).destroy_all
        shahanhdr.shahandtls.destroy_all
        shahanhdr.destroy
      end
      flash[:notice] = "受注番号 #{juchuno} を削除しました。"
    else
      flash[:alert] = "削除対象の受注が見つかりませんでした。"
    end

    # 削除後は一覧画面へリダイレクト
    redirect_to index_sale_path
  end

  def edit
    @is_edit = params[:is_edit]
    @juchuno = params[:juchuno]
    session[:back_to_index] = true  # 必ず一覧に戻る
    # p "=== DEBUG session[:sale_draft] ==="
    # p session[:sale_draft] # ← ここでセッションの中身が空かどうかを確認
    # セッションに保持された一時データ（明細・配送先）があれば読み出して View に渡す
    draft_data = (session[:sale_draft] || {}).with_indifferent_access
    # @items = draft_data[:items] || []
    @selected_delivery = draft_data[:delivery] || {}
    delivno = @selected_delivery[:delivno]
    address_cd = @selected_delivery[:address_cd]
    zipno = @selected_delivery[:zipno]
    p "delivno=" + delivno.to_s
    p "address_cd=" + address_cd.to_s
    p "zipno=" + zipno.to_s

    @receipt_type = "takeout"
    if @selected_delivery[:confirmed].present?
      p "confirmed"
      @receipt_type = "delivery"
    else
      p "no confirmed"
    end
    shaincd = current_shain.shaincd
    if draft_data[:items].present?
      @receipt_type = draft_data[:receipt_type]
      @inputdtls = draft_data[:items]
        p "items ari size=" + @inputdtls.size.to_s
      inputdtl= @inputdtls[0]
      p "items ari color1=" + inputdtl[:color].to_s
      p "items ari size1=" + inputdtl[:size].to_s
    else
      p "items nashi"
      @shahanhdr = Mpls::Shahanhdr.find_by(shaincd: shaincd, juchuno: @juchuno)
      if @shahanhdr.present?
        shodelivkbn = @shahanhdr.shodelivkbn
        if shodelivkbn != "1"
          @receipt_type = "delivery"
          if @shahanhdr.delivno > 0
            shahandlv = Mpls::Shahandlv.find_by(shaincd: shaincd, delivno: @shahanhdr.delivno)
            selection_type = "new"
            delivmei = shahandlv.delivmei
          end
          if @shahanhdr.delivnoshop > 0
            kyakuno = Ff2::Kokyaku.where(ntelno: shaincd.to_s.rjust(6, "0")).maximum(:kyakuno)
            todokesaki = Ff2::Todokesaki.find_by(kyakuno: kyakuno, delivno: @shahanhdr.delivnoshop)
            selection_type = "existing"
            delivmei = todokesaki.delivmei
          end
          @selected_delivery = {
            selection_type: selection_type || "NONE",
            delivno: @shahanhdr.delivnoshop || 0,
            delivmei: delivmei || "",
            delivery_tel: shahandlv.present? ? shahandlv.ntelno : "",
            address_cd: @shahanhdr.adrcd || "",        # 住所コード（郵便番号など）
            address_after: @shahanhdr.adr2 || "",  # 住所（番地・建物名など）
            zipno: shahandlv.present? ? shahandlv.zipno : "",
            dlvappbi: @shahanhdr.dlvappbi,
            dlvkbn: @shahanhdr.dlvkbn
            }
        end
        # 既存の明細を取得して表示用配列を作成
        @inputdtls = @shahanhdr.shahandtls.order(:juchugyo).map do |dtl|
          {
            item_cd: dtl.hinban,
            color: dtl.colorcd,      # ★ 送信された値を保持
            size: dtl.sizecd,        # ★ 送信された値を保持
            colors: nil,    # ★ カラー選択肢群
            sizes: nil,      # ★ サイズ選択肢群
            quantity: dtl.juchusu,
            item_name: dtl.shohin&.hinmeir,
            juchukomigak: dtl.juchugak + dtl.juchutax,
            baika: dtl.baika,
            juchugak: dtl.juchugak,
            juchutax: dtl.juchutax,
            zeirtkbn: dtl.zeirtkbn,
            subtotal: dtl.baika * dtl.juchusu,
            hinmeir: dtl.shohin&.hinmeir
            }
        end
      end
    end
    p "@receipt_type=" + @receipt_type.to_s
  rescue => e
    Rails.logger.debug("【DEBUG】rescueにキャッチされました: #{e.message}")
    # その他例外時
    # flash.now[:alert] = "システムエラーが発生しました。登録をやり直してください。"
    flash.now[:alert] = e.message
    render :edit, status: :unprocessable_entity
  end

  def create
    # 2-2. インスタンスの生成（Strong Parameters を渡す）
    # indexからのパラメータはparamsで、配送画面情報はセッション変数session[:sale_draft]から取得
    # params[:items] = [ { "item_cd" => "123456", "quantity" => "2" }, ... ]
    draft_data = (session[:sale_draft] || {}).with_indifferent_access
    # items_params = draft_data[:items] || []
    items_params = params[:items] || []
    valid_items = items_params.reject { |item| item[:item_cd].blank? }
    @selected_delivery = draft_data[:delivery] || {}
    receipt_type = params[:receipt_type]
    p "receipt_type=" + receipt_type.to_s
    juchuno = params[:juchuno].to_i
    dlvappbi = params.dig(:dlvappbi) || 0
    dlvkbn = params.dig(:dlvkbn) || " "
    p "dlvkbn=" + dlvkbn.to_s

    delivnoshop = 0
    delivno = 0
    adrcd1 = " "
    adrcd2 = " "
    adrcd3 = " "
    adrcd4 = " "
    if receipt_type == "delivery"
      if @selected_delivery[:selection_type] == "new"
        shodelivkbn = "9"
        delivno = @selected_delivery[:delivno]
        delivmei = @selected_delivery[:delivmei]
        delivery_tel = @selected_delivery[:delivery_tel]
        address_after = @selected_delivery[:address_after].to_s
        zipno = @selected_delivery[:zipno]
        address_cd = @selected_delivery[:address_cd]
        address_cd = "00-000-000-000" if address_cd.nil?
        adrcd1 = address_cd[0, 2].to_s
        adrcd2 = address_cd[3, 3].to_s
        adrcd3 = address_cd[7, 3].to_s
        adrcd4 = address_cd[11, 3].to_s
      else
        shodelivkbn = "3"
        delivnoshop = @selected_delivery[:delivno]
      end
    else
      shodelivkbn = "1"
    end
    p "shodelivkbn=" + shodelivkbn.to_s
    p "delivno=" + delivno.to_s
    p "delivnoshop=" + delivnoshop.to_s
    p "address_cd=" + address_cd.to_s
    p "address_after=" + address_after.to_s

    if valid_items.empty?
      p "render step01"
      flash.now[:alert] = "明細を1件以上入力してください。"
      @inputdtls = items_params
      if params(:is_edit) == "true"
        # 一覧表示用のデータを取得
        load_existing_orders
        return render :edit, status: :unprocessable_entity
      else
        return render :new, status: :unprocessable_entity
      end
    end
    # ★ 条件チェック：受取区分が "delivery" かつ、配送先が確定(confirmed)していない場合
    # if receipt_type == "delivery" && !@selected_delivery[:confirmed]
    #   p "render step02"
    #     # エラーメッセージをフラッシュに設定
    #     # flash[:alert] = "配送先が指定・確定されていません。配送先を入力してください。"
    #     #   # 受注画面（または配送先入力画面）へリダイレクト
    #     # redirect_to sale_index_path and return
    #     # if params(:is_edit) == "true"
    #     p "render step02 1"
    #     # 一覧表示用のデータを取得
    #     # load_existing_orders
    #     p "render step02 2"
    #     return render :new, status: :unprocessable_entity
    #   # else
    #   #   return render :new, status: :unprocessable_entity
    #   # end
    # end
    # ② 明細データ確認（各行ループ）
    valid_items.each_with_index do |item_data, index|
      code = item_data[:item_cd].to_s.strip

      gyo = index + 1
      p "baika=" + item_data[:baika].to_s.strip
      # 5,6桁チェックバリデーション
      if not code.match?(/\A\d{5,6}\z/)
        p "render step03"
        flash.now[:alert] = gyo.to_s + "行目 商品コードは半角数字5桁または6桁で入力して下さい。"
        @inputdtls = items_params
        if params(:is_edit) == "true"
          return render :edit, status: :unprocessable_entity
        else
          return render :new, status: :unprocessable_entity
        end
      end
    end

    # # 5,6桁チェックバリデーション
    # invalid_cds = valid_items.reject { |item| item[:item_cd].match?(/\A\d{5,6}\z/) }
    # if invalid_cds.any?
    #   flash.now[:alert] = "商品コードは半角数字5桁または6桁で入力して下さい。"
    #   @inputdtls = items_params
    #   return render :new, status: :unprocessable_entity
    # end
    # [件数, juchunoの最大値] の配列が返ってきます
    # cntdtl, maxjuchuno = Mpls::Shahanhdr.where(shaincd: current_shain.shaincd).pick(
    #   Arel.sql("COUNT('A')"), Arel.sql("MAX(JUCHUNO)"))
    # p "begin tran maxjuchuno=" + maxjuchuno.to_s + " cnt=" + cntdtl.to_s
    shaincd = current_shain.shaincd
    yyyymmdd = Date.today.strftime("%Y%m%d")
    olddelivno = 0
    # DBトランザクションで一括登録処理
    ActiveRecord::Base.transaction do
      p "begin tran " + params[:is_edit].to_s
      if params[:is_edit] == "true"
        shahanhdr = Mpls::Shahanhdr.find_by(shaincd: shaincd, juchuno: juchuno)
        olddelivno = shahanhdr.delivno
        shahanhdr.update!(
          shodelivkbn: shodelivkbn,
          delivno: delivno,
          delivnoshop: delivnoshop,
          dlvappbi: dlvappbi,
          dlvkbn: dlvkbn,
          shakbn: SHAKBN,
          shastabi: yyyymmdd,
          adrcd1: adrcd1,
          adrcd2: adrcd2,
          adrcd3: adrcd3,
          adrcd4: adrcd4,
          adr2: address_after
          )
        # 修正の場合：既存の明細（W_SHAHANDTL）を一旦全削除（作り直し）
        shahanhdr.shahandtls.destroy_all
        maxjuchuno = shahanhdr.juchuno
      else
        if shodelivkbn == "9"
          maxdelivno = Mpls::Shahandlv.where(shaincd: shaincd).maximum(:delivno)
          maxdelivno = 0 if maxdelivno.nil?
          delivno = maxdelivno + 1
        end
        # 新規の場合：受注番号を発行してヘッダーを作成
        maxjuchuno = Mpls::Shahanhdr.where(shaincd: shaincd).maximum(:juchuno)
        maxjuchuno = 0 if maxjuchuno.nil?
        maxjuchuno += 1
        shahanhdr = Mpls::Shahanhdr.create!(
          shaincd: shaincd,
          juchuno: maxjuchuno,
          juchdrsts: "10",
          shodelivkbn: shodelivkbn,
          delivno: delivno,
          delivnoshop: delivnoshop,
          dlvappbi: dlvappbi,
          dlvkbn: dlvkbn,
          adrcd1: adrcd1,
          adrcd2: adrcd2,
          adrcd3: adrcd3,
          adrcd4: adrcd4,
          adr2: address_after,
          shakbn: SHAKBN,
          shastabi: yyyymmdd
          )
      end
      if olddelivno > 0
        shahandlv = Mpls::Shahandlv.find_by(shaincd: shaincd, delivno: olddelivno)
        shahandlv.destroy
      end
      if shodelivkbn == "9"
        shahandlv = Mpls::Shahandlv.create!(
          shaincd: shaincd,
          delivno: delivno,
          delivmei: delivmei,
          ntelno: delivery_tel,
          telno: " ",
          adr1: address_after,
          zipno: zipno
          )
      end
      # ② 明細データ作成（各行ループ）
      valid_items.each_with_index do |item_data, index|
        code = item_data[:item_cd].to_s.strip
        color = item_data[:color].presence || " "
        size = item_data[:size].presence || " "
        quantity = item_data[:quantity].to_i
        baika = item_data[:baika].to_i
        juchugak = baika * quantity
        juchutax = item_data[:juchutax].to_i
        zeirtkbn = item_data[:zeirtkbn].presence || "0"

        # 最新の商品情報をマスターから取得
        product = Ff2::Shohin.find_by!(HINBAN: code, COLORCD: color, SIZECD: size)
        if product
          item_data[:item_name] = product.hinmeir
          # item_data[:baika] = product.baika
        end
        # 辞書ハッシュから税率を取得（0 をデフォルト）千分率の元値
        zeirt = @tax_rate_map[zeirtkbn] || 0
        zeirt = zeirt * 1000
        item_data[:subtotal] = baika * quantity
        # 受注明細を登録
        Mpls::Shahandtl.create!(
          shaincd: shaincd,
          juchuno: maxjuchuno,
          juchugyo: index + 1,
          hinban: code,
          colorcd: color,
          sizecd: size,
          baika: baika,
          juchugak: juchugak,
          juchutax: juchutax,
          zeirtkbn: zeirtkbn,
          zeirt: zeirt,
          juchusu: quantity,
          kakuteisu: quantity
        )
      end
    end

    # ★ 登録成功時：そのままの入力表示を維持し、登録完了フラグを立てる
    @is_edit = true
    @is_completed = true # 登録完了状態フラグ
    @val_readonly = true
    # flash.now[:notice] = "社販受注の登録が完了しました。"
    flash.now[:order_success] = params[:juchuno].present? ? "社販受注の内容を更新しました。" : "社販受注の登録が完了しました。"
    p "iscompleted=" + @is_completed.to_s
    # 最新の入力内容をそのまま表示用に再設定
    # @shahanhdr = Mpls::Shahanhdr.find_by(shaincd: shaincd, juchuno: maxjuchuno)
    # Rails.logger.debug("【DEBUG】render直前のインスタンス変数: #{@is_completed.inspect}")
    # 入力内容を保持したまま画面を再描画
    @inputdtls = valid_items
    @receipt_type = params(:receipt_type)
      # 登録成功したらセッション破棄
      # session.delete(:sale_draft)
      # rebuild_inputdtls(valid_items)
      # if params(:is_edit) == "true"
      #   render :edit
      # else
      render :new
    # end
  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.debug("【DEBUG】rescue1にキャッチされました: #{e.message}")
    # 商品コードが存在しなかった場合のエラーハンドリング
    flash.now[:alert] = "存在しない商品コードが含まれています。"
    @inputdtls = items_params
    render :index, status: :unprocessable_entity

  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.debug("【DEBUG】rescue2にキャッチされました: #{e.message}")
    # バリデーションエラー時
    flash.now[:alert] = "入力内容に不備があります: #{e.message}"
    @inputdtls = items_params
    render :index, status: :unprocessable_entity

  rescue => e
    Rails.logger.debug("【DEBUG】rescue3にキャッチされました: #{e.message}")
    # その他例外時
    # flash.now[:alert] = "システムエラーが発生しました。登録をやり直してください。"
    flash.now[:alert] = e.message
    @inputdtls = items_params
    render :index, status: :unprocessable_entity
  end

  # 受注画面から「配送先入力画面へ」押下時に呼ばれるアクション
  # def save_draft_and_redirect
  #   # 現在の明細入力値を session に保存
  #   session[:sale_draft] ||= {}
  #   session[:sale_draft][:items] = params[:items] # 明細の配列データ
  #   session[:sale_draft][:receipt_type] = params[:receipt_type]

  #   redirect_to delivery_input_sale_index_path
  # end
  def save_draft_and_redirect
    p "save_draft_and_redirect receipt_type=" + params[:receipt_type].to_s
    p "session[:back_to_index]=" + session[:back_to_index].to_s
    # session[:sale_draft] = {
    #   items: params[:items],
    #   is_edit: params[:is_edit],
    #   juchuno: params[:juchuno],
    #   delivno: params[:inidelivno],
    #   delivnoshop: params[:inidelivnoshop],
    #   receipt_type: params[:receipt_type]
    # }
    # 既存のセッションデータを取得（なければ空のハッシュ）して indifferent access にする
    draft = (session[:sale_draft] || {}).with_indifferent_access
    delivery = draft[:delivery] || {}

    # 各パラメータをセッションに格納
    draft[:items] = params[:items]
    p "items size=" + draft[:items].size.to_s
    itemdtl = params[:items][0]
    p "items item_cd=" + itemdtl[:item_cd].to_s
    p "items hinmeir=" + itemdtl[:hinmeir].to_s
    draft[:is_edit] = params[:is_edit]
    p "save_draft_and_redirect is_edit=" + draft[:is_edit].to_s
    draft[:juchuno] = params[:juchuno]
    draft[:receipt_type] = params[:receipt_type]
    p "delivno=" + params[:delivno].to_s
    # ★ 画面上で入力・選択されている配送先情報を delivery キーにまとめて保存する
    draft[:delivery] = {
      confirmed: delivery[:confirmed],
      selection_type: params[:selection_type] || "NONE",
      delivno: params[:delivno] || "0",
      delivmei: params[:delivmei] || "",
      delivery_tel: params[:delivery_tel] || "",
      address_cd: params[:address_cd] || "",        # 住所コード（郵便番号など）
      address_after: params[:address_after] || "",  # 住所（番地・建物名など）
      zipno: params[:zipno] || "",                   # 必要に応じて郵便番号
      dlvappbi: params[:dlvappbi] || "0",
      dlvkbn: params[:dlvkbn] || ""
}

    session[:sale_draft] = draft
    head :ok # 成功のステータス（200）を返す
  end

  # 配送先選択画面
  def delivery_input
    p "session[:back_to_index]=" + session[:back_to_index].to_s
    # 配送先マスターの一覧取得など
    kyakuno = Ff2::Kokyaku.where(ntelno: current_shain.shaincd.to_s.rjust(6, "0")).maximum(:kyakuno)
    if kyakuno
      p kyakuno
      # 社員CDで絞り込んで最新順に取得
      @deliveries = Ff2::Todokesaki.where(kyakuno: kyakuno)
                                .order(delivno: :desc)
                                .includes(:address).map { |addr|
        {
          delivno: addr.delivno,
          delivmei: addr.delivmei,
          tel: addr.ntelno,
          full_address: addr.fulladr + addr.adr2.presence || "" + addr.adr3.presence || ""
        }
      }
    end
    p "from=" + params[:from].to_s if params[:from].presence
    # 現在セッション（または既存受注）に保持されている配送先情報を取得
    draft_data = (session[:sale_draft] || {}).with_indifferent_access
    delivery_data = draft_data[:delivery] || {}
    itemdtl = draft_data[:items][0]
    p "items item_cd=" + itemdtl[:item_cd].to_s
    p "items hinmeir=" + itemdtl[:hinmeir].to_s
    p "mode=" + draft_data[:mode].to_s
    # ★ 「セッションにデータがあり、かつユーザーが apply_delivery で確定させたもの」だけを最優先する
    if delivery_data[:confirmed].present?
      @current_delivery = draft_data[:delivery]
      p "delivery_input present address_after=" + draft_data[:address_after].to_s
    else
      p "delivery_input no present is_edit=" + draft_data[:is_edit].to_s
      # elsif draft_data[:receipt_type] = "delivery"
      selection_type = "NONE"
      delivmei = ""
      address_cd = ""
      shaincd = current_shain.shaincd
      if draft_data[:is_edit] && draft_data[:juchuno].to_i > 0
        shahanhdr = Mpls::Shahanhdr.find_by(shaincd: shaincd, juchuno: draft_data[:juchuno].to_i)
        if shahanhdr.delivno > 0
          shahandlv = Mpls::Shahandlv.find_by(shaincd: shaincd, delivno: shahanhdr.delivno)
          p "shahandlv.delivmei=" + shahandlv.delivmei.to_s
          address_cd = shahanhdr.adrcd
          selection_type = "new"
          delivmei = shahandlv.delivmei
        end
        if shahanhdr.delivnoshop > 0
          kyakuno = Ff2::Kokyaku.where(ntelno: shaincd.to_s.rjust(6, "0")).maximum(:kyakuno)
          todokesaki = Ff2::Todokesaki.find_by(kyakuno: kyakuno, delivno: shahanhdr.delivnoshop)
          p "todokesaki.delivmei=" + todokesaki.delivmei.to_s
          selection_type = "existing"
          delivmei = todokesaki.delivmei
        end
      end
      # セッションになければ、既存のDBデータ（修正元の受注）から初期値を組み立ててセッションに保存する
      # 例: @shahanhdr から delivno, address_cd などを取得してハッシュにする
      @current_delivery = {
        selection_type: selection_type,
        delivno: (shahanhdr.present? ? shahanhdr.delivnoshop : 0),
        delivmei: delivmei,
        address_cd: address_cd,
        address_after: (shahanhdr.present? ? shahanhdr.adr2 : ""),
        delivery_tel: (shahandlv.present? ? shahandlv.ntelno : ""),
        zipno: (shahandlv.present? ? shahandlv.zipno : "")
      }
      # 初回構築時のみセッションに反映しておく
      draft_data[:delivery] = @current_delivery
      session[:sale_draft] = draft_data
    end
    p "selection_type=" + @current_delivery[:selection_type].to_s
    if @current_delivery[:selection_type] == "new"
      # 前回が新規配送先の時は、市区町村をデフォルト表示する
      @adrcd = @current_delivery[:address_cd]
      p "@adrcd=" + @adrcd.to_s
    end
    # 呼び出し元（new または edit）をセッションに保持
    if params[:mode].present?
      p "mode=" + params[:mode].to_s
      session[:delivery_back_mode] = params[:mode]
      session[:delivery_target_juchuno] = params[:juchuno] if params[:juchuno].present?
    else
      p "mode none"
    end
  end

  # 配送先画面で「この配送先を選択」押下時に呼ばれるアクション
  def apply_delivery
    @receipt_type = "delivery"
    # 選択した配送先情報を session に追記
    session[:sale_draft] ||= {}

    p "apply_delivery address_after=" + params[:new_address_after].to_s
    if params[:selection_type] == "new"
      p "apply_delivery new adrcd=" + params[:new_address_cd].to_s
      # 新規配送先情報の適用
      session[:sale_draft][:delivery] = {
        confirmed: true, # ★ ここがポイント！ユーザーが決定した証拠
        selection_type: "new",
        delivno: "0", # 新規なので番号はzero
        delivmei: params[:delivmei],
        delivery_tel: params[:delivery_tel],
        address_cd: params[:new_address_cd],
        address_after: params[:new_address_after],
        zipno: params[:new_zip]
      }
    else
      p "apply_delivery exist delivno=" + params[:delivno].to_s
      # 一覧からの選択
      session[:sale_draft][:delivery] = {
        confirmed: true,
        selection_type: "existing",
        delivno: params[:delivno],
        delivmei: params[:delivmei],
        delivery_tel: params[:tel],
        address_cd: params[:adrcd],
        address_after: params[:address_after],
        zipno: params[:new_zip]
      }
    end

    # 受注登録画面（index）へ戻る
    # redirect_to sale_index_path
    # 呼び出し元（mode）に応じてリダイレクト先を分岐
    if session[:delivery_back_mode] == "edit" && session[:delivery_target_juchuno].present?
      redirect_to edit_sale_path(is_edit: "true", juchuno: session[:delivery_target_juchuno])
    else
      redirect_to new_sale_path
    end
  end

  private
  # 一覧データを組み立てる共通メソッド
  def load_existing_orders
    p "load_existing_orders in"
    shaincd = current_shain.shaincd
    shahanhdrs  = Mpls::Shahanhdr.where(shaincd: shaincd, pickflg: 0).order(:juchuno)
    @existing_orders = []
    shahanhdrs.each do |hdr|
      delivmei = "持帰り"
      if hdr.delivno > 0
        shahandlv = Mpls::Shahandlv.find_by(shaincd: shaincd, delivno: hdr.delivno)
        delivmei = shahandlv.delivmei
      end
      if hdr.delivnoshop > 0
        kyakuno = Ff2::Kokyaku.where(ntelno: shaincd.to_s.rjust(6, "0")).maximum(:kyakuno)
        todokesaki = Ff2::Todokesaki.find_by(kyakuno: kyakuno, delivno: hdr.delivnoshop)
        delivmei = todokesaki.delivmei
      end
      hinmeir = Mpls::Shahandtl.find_by(shaincd: shaincd, juchuno: 1).hinmeir
      order = {
        juchuno: hdr.juchuno,
        total_amount: hdr.shahandtls.sum { |dtl| dtl.juchugak + dtl.juchutax },
        first_item_name: hinmeir.to_s,
        item_count: hdr.shahandtls.size,
        delivmei: delivmei
        }
      @existing_orders  << order
    end
    p "load_existing_orders end"
  end

  # 💡 税率マップ作成処理を共通化
  def set_tax_rate_map
    # m_codemei から codekbn="316" の税率マスタを取得・変換
    @tax_rate_table = Ff2::Codemei.where(codekbn: "316").order(:codekey).map do |m|
      # codenum1 が 100 の場合は 0.10、80 の場合は 0.08 に変換
      promille = m.codenum1.to_f
      rate = promille / 1000.0
      {
        tax_kbn: m.codekey[0, 1],   # 税率区分コード (例: "0", "1")
        tax_name: m.codemeir,       # 税率名 (例: "10%", "8%")
        promille: m.codenum1.to_i,  # 千分率整数 (例: 100, 80)
        tax_rate: rate              # 計算用税率 (例: 0.1, 0.08)
      }
    end
    # 区分コード(code)をキーにして、即座に税率(0.10等)を引ける辞書ハッシュを作成
    @tax_rate_map = @tax_rate_table.each_with_object({}) do |item, hash|
      hash[item[:tax_kbn]] = item[:tax_rate]
    end
  end
end
