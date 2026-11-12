class Ff2::Address < Ff2Record
  self.table_name = "M_ADDRESS"
  self.primary_key = [ :adrcd1, :adrcd2, :adrcd3, :adrcd4 ]

  has_many :todokesaki,
    class_name: "Ff2::Todokesaki",
    foreign_key: [ :adrcd1, :adrcd2, :adrcd3, :adrcd4 ],
    primary_key: [ :adrcd1, :adrcd2, :adrcd3, :adrcd4 ]

    has_many :shahanhdr,
    class_name: "Mpls::Shahanhdr",
    foreign_key: [ :adrcd1, :adrcd2, :adrcd3, :adrcd4 ],
    primary_key: [ :adrcd1, :adrcd2, :adrcd3, :adrcd4 ]

  def fulladr
    "#{kenknjmei}#{adr1knj}"
  end
end
