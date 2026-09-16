class Mpls::Shahandtl < ApplicationRecord
  self.table_name = "W_SHAHANDTL"
  self.primary_key = [ :shaincd, :juchuno, :juchugyo ]

  #  has_one :shohin,
  #    class_name: "Ff2::Shohin",
  #    foreign_key: [ :hinban, :colorcd, :sizecd ],
  #    primary_key: [ :hinban, :colorcd, :sizecd ]
  def shohin
    # RPAD関数を使って、DB側の末尾スペースを補完状態で比較する
    # これにより、Rails側の "" (空文字) と正しく一致するようになります
    query = Ff2::Shohin.where(hinban: hinban)
    if colorcd.blank?
      query = query.where("colorcd = RPAD(' ', 3)")
    else
      query = query.where(colorcd: colorcd)
    end
    if sizecd.blank?
      query = query.where("sizecd = RPAD(' ', 4)")
    else
      query = query.where(sizecd: sizecd)
    end
    query.first
    # Ff2::Shohin.where(hinban: hinban)
    #             .where(RPAD(colorcd:) colorcd)
    #             .where(RPAD(sizecd:) sizecd)
    #             .first
  end

  belongs_to :shahanhdr,
    class_name: "Mpls::Shahanhdr",
    foreign_key: [ :shaincd, :juchuno ]

  attribute :created_at, :datetime
  attribute :updated_at, :datetime

  validates :shaincd, presence: true
  validates :juchuno, presence: true
  validates :juchugyo, presence: true
  # 5桁または6桁の数字を許容
  validates :hinban, presence: true, format: { with: /\A\d{5,6}\z/, message: "は半角数字5桁または6桁で入力してください" }
  validates :juchusu, presence: true, numericality: { greater_than: 0 }
  # def valid_password?(input_password)
  #   self.password == input_password
  # end
end
