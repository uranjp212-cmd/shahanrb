class Mpls::Shahanhdr < ApplicationRecord
  self.table_name = "W_SHAHANHDR"
  self.primary_key = [ :shaincd, :juchuno ]
  has_many :shahandtls,
    class_name: "Mpls::Shahandtl",
    foreign_key: [ :shaincd, :juchuno ],
    dependent: :destroy

  attribute :created_at, :datetime
  attribute :updated_at, :datetime

  validates :shaincd, presence: true
  validates :juchuno, presence: true
  # def valid_password?(input_password)
  #   self.password == input_password
  # end
end
