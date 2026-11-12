class Mpls::Shahandlv < ApplicationRecord
  self.table_name = "W_SHAHAN_WEBORDER_DLV"
  self.primary_key = [ :shaincd, :delivno ]

  attribute :created_at, :datetime
  attribute :updated_at, :datetime
end
