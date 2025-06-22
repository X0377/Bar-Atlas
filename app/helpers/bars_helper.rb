module BarsHelper
  def search_performed?
    params[:q].present? && params[:q].values.any? { |_, v| v.present? }
  end
end
