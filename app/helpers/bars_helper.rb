module BarsHelper
  def search_performed?
    params[:q].present? && (
      params.dig(:q, :name_or_address_or_phone_or_smoking_status_or_description_or_specialties_category_cont).present? ||
      params.dig(:q, :address_cont).present? ||
      params.dig(:q, :price_category_eq).present? ||
      params.dig(:q, :smoking_status_eq).present?
    )
  end
end
