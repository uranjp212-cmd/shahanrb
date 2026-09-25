class ProductsController < ApplicationController
  before_action :require_shain_login

  # GET /products/search_by_hinban?hinban=123456
  def search_by_hinban
    hinban = params[:hinban].to_s.strip
    # 品番に一致する商品をすべて取得
    products = Ff2::Shohin.where(HINBAN: hinban)
    if products.empty?
      render json: { found: false, message: "該当する商品がありません" }
      return
    end

    # ★ カラー・サイズが空白のデータのみ（単一商品）かどうかの判定
    # （または products.size == 1 などの判定）
    first_product = products.first
    is_single = products.size == 1 && first_product.colorcd.blank? && first_product.sizecd.blank?

    p "search_by_hinban " + hinban.to_s, is_single
    if is_single
      render json: {
        found: true,
        is_single: true,
        name: first_product.hinmeir,
        price: first_product.baika
      }
    else
      # 複数バリエーションが存在する場合
      colors = products.map(&:colorcd).reject(&:blank?).uniq
      color_size_map = {}
      products.each do |p|
        next if p.colorcd.blank?
        color_size_map[p.colorcd] ||= []
        color_size_map[p.colorcd] << { size: p.sizecd, price: p.baika }
      end

      render json: {
        found: true,
        is_single: false,
        name: first_product.hinmeir,
        colors: colors,
        color_size_map: color_size_map
      }
    end
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
