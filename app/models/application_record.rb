class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
  # 自作の Type クラスを定義して、Integer（8桁）と Date を相互変換する
  class EightDigitDateType < ActiveRecord::Type::Date
    def cast(value)
      return nil if value.blank?
      return value if value.is_a?(Date)
      # 文字列や数値から Date に変換
      Date.parse(value.to_s) rescue nil
    end
    def serialize(value)
      return 0 if value.blank?
      value.is_a?(Date) ? value.strftime("%Y%m%d").to_i : value.to_i
    end
  end
end
