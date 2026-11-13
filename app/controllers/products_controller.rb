class ProductsController < ApplicationController
  before_action :require_shain_login
  before_action :set_taxnew_map, only: [ :search_by_hinban ]
  SHA_WARIRT = 0.1
  PROMO_SHAHAN = "SHA001"
  PROMO_OUT = "1"

  def set_taxnew_map
    # 新税率区分をセット
    apldate = Ff2::Control.find_by(cntrlkbn: 1, cntrlkey: "1").cntrlnum1
    newtax_table = Ff2::Codemei.where(codekbn: "316").order(:codekey).map do |m|
      # codenum2 以降は 新税率区分を使用する
      newtax = m.codekey[0, 1]
      if m.codenum2 <= apldate
        newtax = m.codestr1[0, 1]
      end
      {
        tax_kbn: m.codekey[0, 1],   # 税率区分コード (例: "0", "1")
        tax_new: newtax
      }
    end
    # 区分コード(code)をキーにして、即座に新税率区分を引ける辞書ハッシュを作成
    @newtax_map = newtax_table.each_with_object({}) do |item, hash|
      hash[item[:tax_kbn]] = item[:tax_new]
    end
  end

  # GET /products/search_by_hinban?hinban=123456
  def search_by_hinban
    hinban = params[:hinban].to_s.strip
    p "search_by_hinban in=" + hinban
    retno = read_shahan(hinban)
    retno = read_out(hinban) if retno == 9
    read_shohin(hinban) if retno == 9
  end

  def read_shahan(hinban)
    products = Ff2::Proshohin.where(PROMOCD: PROMO_SHAHAN, PROHINBAN: hinban)
    if products.empty?
      return 9
    end
    p "社販プロモあり"
    out_jason(products)
  end

  def read_out(hinban)
    products = Ff2::Proshohin.where(PROMOCD: PROMO_OUT, PROHINBAN: hinban)
    if products.empty?
      return 9
    end
    p "アウトプロモあり"
    out_jason(products)
  end

  def out_jason(products)
    first_product = products.first
    # 重複を除いた全カラー・全サイズのリスト（空白も1つの要素として保持）
    all_colors = products.map { |p| p.procolcd.to_s.presence || " " }.uniq
    all_sizes  = products.map { |p| p.prosizecd.to_s.presence || " " }.uniq
    # p "idx color=" + all_colors.size.to_s + ", size=" + all_sizes.size.to_s

    # カラー・サイズ・単価のマッピングデータ
    color_size_map = {}
    products.each do |p|
      colorcd = p.procolcd.to_s.presence || " "
      sizecd = p.prosizecd.to_s.presence || " "
      # p "color=" + colorcd + ", size=" + sizecd
      # next if p.colorcd.blank?
      color_size_map[colorcd] ||= []
      # 社員割引価格
      if p.promocd == PROMO_SHAHAN
        baika = p.baika
      else
        baika = p.baika * SHA_WARIRT
        baika = p.baika - baika.to_i
      end
      color_size_map[colorcd] << { size: sizecd, price: baika }
    end
    # zeirtkbn = get_zeirtkbn(first_product.zeirtkbn)
    zeirtkbn = @newtax_map[first_product.zeirtkbn] || '0'
    # p "zeritkbn=" + zeirtkbn.to_s + ", m=" + first_product.zeirtkbn.to_s
    # 社員割引価格
    if first_product.promocd == PROMO_SHAHAN
      baika = first_product.baika
    else
      baika = first_product.baika * SHA_WARIRT
      baika = first_product.baika - baika.to_i
    end
    # p "prosho zeirtkbn=" + zeirtkbn.to_s + ", DB kbn=" + first_product.zeirtkbn
    render json: {
      found: true,
      name: first_product.proshomeir,
      price: baika,
      zeirtkbn: zeirtkbn,
      colors: all_colors,
      sizes: all_sizes,
      color_size_map: color_size_map
    }
  end

  def read_shohin(hinban)
    # 品番に一致する商品をすべて取得
    products = Ff2::Shohin.where(HINBAN: hinban)
    if products.empty?
      render json: { found: false, message: "該当する商品がありません" }
      return
    end

    p "search_by_hinban 商品マスタ" + hinban.to_s
    first_product = products.first

    # 重複を除いた全カラー・全サイズのリスト（空白も1つの要素として保持）
    all_colors = products.map { |p| p.colorcd.to_s.presence || " " }.uniq
    all_sizes  = products.map { |p| p.sizecd.to_s.presence || " " }.uniq

    # カラー・サイズ・単価のマッピングデータ
    color_size_map = {}
    # products.each do |p|
    #   c = p.colorcd.to_s.presence || " "
    #   s = p.sizecd.to_s.presence || " "
    #   # p "color_size_map", c, s
    #   color_size_map[c] ||= {}
    #   color_size_map[c][s] = p.baika
    # end
    products.each do |p|
      colorcd = p.colorcd.to_s.presence || " "
      sizecd = p.sizecd.to_s.presence || " "
      # 社員割引価格
      baika = p.baika * SHA_WARIRT
      baika = p.baika - baika.to_i
      # next if p.colorcd.blank?
      color_size_map[colorcd] ||= []
      color_size_map[colorcd] << { size: sizecd, price: baika }
    end

    # 社員割引価格
    baika = first_product.baika * SHA_WARIRT
    baika = first_product.baika - baika.to_i
    # zeirtkbn = get_zeirtkbn(first_product.zeirtkbn)
    zeirtkbn = @newtax_map[first_product.zeirtkbn] || '0'
    p "shohin zeirtkbn=" + zeirtkbn.to_s + ", DB kbn=" + first_product.zeirtkbn
    render json: {
      found: true,
      name: first_product.hinmeir,
      price: baika,
      zeirtkbn: zeirtkbn,
      colors: all_colors,
      sizes: all_sizes,
      color_size_map: color_size_map
    }
  end

  # GET /products/search?code=123456
  def search
    item_cd = params[:code]&.strip

    p "search in"

    # 商品マスターから検索 (テーブル・カラム名は環境に合わせて変更してください)
    # 例: M_SHOOHIN テーブル (SHOOHINCD, SHOOHINNAME, TANKA)
    # product = Ff2::Shohin.find_by(HINBAN: item_cd, COLORCD: " ", SIZECD: " ")
    product = Ff2::Shohin.find_by(HINBAN: item_cd)
    if product
      render json: {
        found: true,
        name: product.hinmeir,
        price: product.baika
      }
    else
      render json: {
        found: false,
        message: "該当する商品がありません"
      }
    end
  end
end
