class Mpls::Shahanhdr < ApplicationRecord
  self.table_name = "W_SHAHANHDR"
  self.primary_key = [ :shaincd, :juchuno ]
  has_many :shahandtls,
    class_name: "Mpls::Shahandtl",
    foreign_key: [ :shaincd, :juchuno ],
    dependent: :destroy

  attribute :created_at, :datetime
  attribute :updated_at, :datetime
  attribute :shakbn, :integer

  validates :shaincd, presence: true
  validates :juchuno, presence: true

  belongs_to :address,
              class_name: "Ff2::Address",
              foreign_key: %i[adrcd1 adrcd2 adrcd3 adrcd4], primary_key: %i[adrcd1 adrcd2 adrcd3 adrcd4], optional: true
  # shahanhdr.fulladr で直接呼べるようになります（オプション）
  delegate :fulladr, to: :address, allow_nil: true
  def adrall
    "#{fulladr}#{adr2}"
  end
  def adrcd
    "#{adrcd1}-#{adrcd2}-#{adrcd3}-#{adrcd4}"
  end
end
