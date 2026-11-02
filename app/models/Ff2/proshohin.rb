class Ff2::Proshohin < Ff2Record
  self.table_name = "M_PROSHOHIN"
  self.primary_key = [ :promocd, :prohinban, :procolcd, :prosizecd ]
end
