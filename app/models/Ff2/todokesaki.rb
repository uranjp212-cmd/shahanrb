class Ff2::Todokesaki < Ff2Record
  self.table_name = "M_TODOKESAKI"
  self.primary_key = [ :kyakuno, :delivno ]

  belongs_to :address, foreign_key: %i[adrcd1 adrcd2 adrcd3 adrcd4], primary_key: %i[adrcd1 adrcd2 adrcd3 adrcd4], optional: true

  # delegateを使うと、todokesaki.KENKNJMEI で直接呼べるようになります（オプション）
  delegate :fulladr, to: :address, allow_nil: true
  def adrcd
    "#{adrcd1}-#{adrcd2}-#{adrcd3}-#{adrcd4}"
  end
  def adr23
    "#{adr2}　#{adr3}"
  end
end
