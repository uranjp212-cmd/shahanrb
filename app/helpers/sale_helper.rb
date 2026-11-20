module SaleHelper
  def new_delivery_value(current_delivery, key)
    return "" unless current_delivery.present? && current_delivery[:selection_type] == "new"
    current_delivery[key]
  end
end
