class DeliveryAddressesController < ApplicationController
  # GET /delivery_addresses
  # ログイン社員に紐づく配送先一覧（JSON）を返す
  def index
    kyakuno = Ff2::Kokyaku.where(ntelno: current_shain.shaincd.to_s.rjust(6, "0")).maximum(:kyakuno)
    p kyakuno
    # 社員CDで絞り込んで最新順に取得
    delives = Ff2::Todokesaki.where(kyakuno: kyakuno)
                               .order(delivno: :desc)
                               .includes(:address)
    p delives.size
    render json: delives.map { |addr|
      {
        delivno: addr.delivno,
        delivmei: addr.delivmei,
        tel: addr.ntelno,
        adrcd: addr.adrcd,
        adr2: addr.adr23.presence || "",
        full_address: addr.fulladr + "　" + addr.adr23.presence || ""
      }
    }
  end

  # GET /delivery_addresses/search_address?zip=1234567
  # 郵便番号から住所マスタ（AddressMaster）を検索するAPI
  def search_address
    zip = params[:zip].to_s.gsub(/[^0-9]/, "") # ハイフンを除去して数字のみにする

    # 該当する郵便番号の住所マスタをすべて取得
    addresses = Ff2::Address.where(zipno: zip)
p addresses.size
    if addresses.any?
      candidates = addresses.map do |addr|
        {
          adrcd1: addr.adrcd1,
          adrcd2: addr.adrcd2,
          adrcd3: addr.adrcd3,
          adrcd4: addr.adrcd4,
          full_address_text: addr.fulladr
        }
      end

      render json: { found: true, candidates: candidates }
    else
      render json: { found: false, message: "該当する住所が見つかりませんでした。" }
    end
  end
end