class SaleController < ApplicationController
  before_action :require_shain_login # 社員ログイン必須チェック
  def index
    shaincd = current_shain.shaincd
    maxjuchuno = Mpls::Shahanhdr.where(shaincd: shaincd, pickflg: 0).maximum(:juchuno)
    maxjuchuno = 0 if maxjuchuno.nil?
    p "maxjuchuno=" + maxjuchuno.to_s
    @shahanhdr = Mpls::Shahanhdr.find_by(shaincd: shaincd, juchuno: maxjuchuno)
    if @shahanhdr.present?
      p "juchunoあり"
      # 【修正画面パターン】既に受注が存在する場合
      @is_edit = true
      # 既存の明細を取得して表示用配列を作成
      @inputdtls = @shahanhdr.shahandtls.order(:juchugyo).map do |dtl|
        {
          item_cd: dtl.hinban,
          quantity: dtl.juchusu,
          item_name: dtl.shohin&.hinmeir,
          price: dtl.salebaika,
          subtotal: dtl.salebaika * dtl.juchusu
          }
      end
    else
      @is_edit = false
      @shahanhdr = Mpls::Shahanhdr.new
      # 初期表示用に空行を3行用意
      @inputdtls = Array.new(3) { { item_cd: "", quantity: 1, item_name: "", price: 0, subtotal: 0 } }
    end
  end

  def create
    # 送信された複数行のパラメータを取得
    # params[:items] = [ { "item_cd" => "123456", "quantity" => "2" }, ... ]
    items_params = params[:items] || []
    valid_items = items_params.reject { |item| item[:item_cd].blank? }

    if valid_items.empty?
      flash.now[:alert] = "明細を1件以上入力してください。"
      @inputdtls = items_params
      return render :new, status: :unprocessable_entity
    end

    # ② 明細データ確認（各行ループ）
    valid_items.each_with_index do |item_data, index|
      code = item_data[:item_cd].to_s.strip
      # quantity = item_data[:quantity].to_i

      gyo = index + 1
      # 5,6桁チェックバリデーション
      if not code.match?(/\A\d{5,6}\z/)
        flash.now[:alert] = gyo.to_s + "行目 商品コードは半角数字5桁または6桁で入力して下さい。"
        @inputdtls = items_params
        return render :new, status: :unprocessable_entity
      end
      # # 商品情報をマスターから取得  rescueがあるから不要
      # product = Ff2::Shohin.find_by!(HINBAN: code, COLORCD: " ", SIZECD: " ")
      # if product
      #   item_data[:item_name] = product.hinmeir
      #   item_data[:price] = product.baika
      #   item_data[:subtotal] = product.baika * quantity
      # else
      #   flash.now[:alert] = gyo.to_s + "行目 商品コードを正しく入力して下さい。"
      #   @inputdtls = items_params
      #   return render :new, status: :unprocessable_entity
      # end
      # p item_data[:item_name], item_data[:price],  item_data[:subtotal]
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
    maxjuchuno = Mpls::Shahanhdr.where(shaincd: shaincd, pickflg: 0).maximum(:juchuno)
    maxjuchuno = 0 if maxjuchuno.nil?
    p "begin tran maxjuchuno=" + maxjuchuno.to_s
    # DBトランザクションで一括登録処理
    ActiveRecord::Base.transaction do
      shahanhdr = Mpls::Shahanhdr.find_by(shaincd: shaincd, juchuno: maxjuchuno)
      if shahanhdr.nil?
        # 新規の場合：受注番号を発行してヘッダーを作成
        maxjuchuno = Mpls::Shahanhdr.where(shaincd: shaincd).maximum(:juchuno)
        maxjuchuno = 0 if maxjuchuno.nil?
        maxjuchuno += 1
        shahanhdr = Mpls::Shahanhdr.create!(
          shaincd: shaincd,
          juchuno: maxjuchuno
        )
      else
        # 修正の場合：既存の明細（W_SHAHANDTL）を一旦全削除（作り直し）
        shahanhdr.shahandtls.destroy_all
        maxjuchuno = shahanhdr.juchuno
      end
      # ② 明細データ作成（各行ループ）
      valid_items.each_with_index do |item_data, index|
        code = item_data[:item_cd].to_s.strip
        quantity = item_data[:quantity].to_i

        # 最新の商品情報をマスターから取得
        product = Ff2::Shohin.find_by!(HINBAN: code, COLORCD: " ", SIZECD: " ")
        if product
          item_data[:item_name] = product.hinmeir
          item_data[:price] = product.baika
          item_data[:subtotal] = product.baika * quantity
        end
        p "begin dtl ix=" + index.to_s
        # 受注明細を登録
        Mpls::Shahandtl.create!(
          shaincd: shaincd,
          juchuno: maxjuchuno,
          juchugyo: index + 1,
          hinban: product.hinban,
          salebaika: product.baika,
          juchusu: quantity
        )
      end
    end

    # ★ 登録成功時：そのままの入力表示を維持し、登録完了フラグを立てる
    @is_edit = true
    @is_completed = true # 登録完了状態フラグ
    # flash.now[:notice] = "社販受注の登録が完了しました。"
    flash.now[:order_success] = params[:juchuno].present? ? "社販受注の内容を更新しました。" : "社販受注の登録が完了しました。"
    p "iscompleted=" + @is_completed.to_s
    # 最新の入力内容をそのまま表示用に再設定
    @shahanhdr = Mpls::Shahanhdr.find_by(shaincd: shaincd, juchuno: maxjuchuno)
    # Rails.logger.debug("【DEBUG】render直前のインスタンス変数: #{@is_completed.inspect}")
    # 入力内容を保持したまま画面を再描画
    @inputdtls = valid_items
    # rebuild_inputdtls(valid_items)
    render :new

  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.debug("【DEBUG】rescue1にキャッチされました: #{e.message}")
    # 商品コードが存在しなかった場合のエラーハンドリング
    flash.now[:alert] = "存在しない商品コードが含まれています。"
    @inputdtls = items_params
    render :new, status: :unprocessable_entity

  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.debug("【DEBUG】rescue2にキャッチされました: #{e.message}")
    # バリデーションエラー時
    flash.now[:alert] = "入力内容に不備があります: #{e.message}"
    @inputdtls = items_params
    render :new, status: :unprocessable_entity

  rescue => e
    Rails.logger.debug("【DEBUG】rescue3にキャッチされました: #{e.message}")
    # その他例外時
    # flash.now[:alert] = "システムエラーが発生しました。登録をやり直してください。"
    flash.now[:alert] = e.message
    @inputdtls = items_params
    render :new, status: :unprocessable_entity
  end
end
