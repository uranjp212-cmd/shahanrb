class Ff2::Shohin < Ff2Record
  self.table_name = "M_SHOHIN"
  self.primary_key = [ :hinban, :colorcd, :sizecd ]

  belongs_to :shahandtl, foreign_key: %i[hinban colorcd sizecd], primary_key: %i[hinban colorcd sizecd]
end
