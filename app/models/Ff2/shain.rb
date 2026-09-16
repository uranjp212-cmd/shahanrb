class Ff2::Shain < Ff2Record
  self.table_name = "M_SHAIN"
  self.primary_key = :shaincd
  attr_accessor :passwrd
  passwrd = 9999
  def valid_password?(input_password)
    self.password == input_password
  end
end
