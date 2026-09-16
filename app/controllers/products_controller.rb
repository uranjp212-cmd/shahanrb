class ProductsController < ApplicationController
  before_action :require_shain_login

  # GET /products/search?code=123456
  def search
    item_cd = params[:code]&.strip

    # 商品マスターから検索 (テーブル・カラム名は環境に合わせて変更してください)
    # 例: M_SHOOHIN テーブル (SHOOHINCD, SHOOHINNAME, TANKA)
    product = Ff2::Shohin.find_by(HINBAN: item_cd, COLORCD: " ", SIZECD: " ")
    p product
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
