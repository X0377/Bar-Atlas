class BarsController < ApplicationController
  before_action :set_bar, only: %i[show]

  def index
    keyword_search = params.dig(:q, :name_or_address_or_phone_or_smoking_status_or_description_or_specialties_category_cont)
    other_params = params.fetch(:q, {}).except(:name_or_address_or_phone_or_smoking_status_or_description_or_specialties_category_cont)
                        .reject { |key, value| value.blank? }

    @q = Bar.ransack(other_params)
    @bars = @q.result.includes(:specialties)

    if keyword_search.present?
      @bars = @bars.search_by_keywords(keyword_search)
    end

    @bars = apply_sorting(@bars)

    @bars = @bars.distinct

    if helpers.search_performed?
      @bars = @bars.page(params[:page]).per(20)
    else
      @bars = @bars.limit(12)
    end

    @total_count = @bars.count

    # Google Maps用データを別途取得
    map_query_base = Bar.where.not(latitude: nil, longitude: nil)

    if helpers.search_performed?
      map_query = @q.result
      if keyword_search.present?
        map_query = map_query.search_by_keywords(keyword_search)
      end
      map_query_base = map_query.where.not(latitude: nil, longitude: nil).distinct
    end

    @bars_for_map_count = map_query_base.count

    @bars_for_map = map_query_base.select(:id, :name, :address, :phone, :business_hours,
                                         :price_range, :latitude, :longitude, :smoking_status)
  end

  def show
    @bar = Bar.find(params[:id])
  end

  private

  def set_bar
    @bar = Bar.find(params[:id])
  end

  def apply_sorting(relation)
    case params[:sort]
    when 'created_at_desc'
      relation.order(created_at: :desc)
    when 'name_asc'
      relation.order(:name)
    when 'price_asc'
      relation.order(:price_range)
    when 'price_desc'
      relation.order(price_range: :desc)
    else
      relation.order(created_at: :desc)
    end
  end

  def bar_params
    params.require(:bar).permit(
      :name, :address, :price_range, :smoking_status,
      :description, :phone, :business_hours, :image_url
    )
  end
end
