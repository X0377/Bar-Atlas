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

    @bars = @bars.distinct
    @bars = apply_sorting(@bars)

    if helpers.search_performed?
      @bars = @bars.page(params[:page]).per(20)
    else
      @bars = @bars.limit(12)
    end

    @total_count = @bars.count
    # @filter_counts = calculate_filter_counts
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

# TODO: フィルター件数機能は後日実装
=begin
  def calculate_filter_counts
    areas = %w[新宿 六本木 恵比寿 渋谷]
    area_counts = Bar.where(
      areas.map { |area| "address ILIKE ?" }.join(' OR '),
      *areas.map { |area| "%#{area}%" }
    ).group("CASE #{areas.map.with_index { |area, i|
      "WHEN address ILIKE '%#{area}%' THEN '#{area}'"
    }.join(' ')} END").count

    {
      area: areas.map { |area| [area, area_counts[area] || 0] }.to_h,
      price_category: {
        'reasonable' => Bar.where("price_range LIKE '%¥2,000-4,000%'").count,
        'standard' => Bar.where("price_range LIKE '%¥3,000-5,000%' OR price_range LIKE '%¥4,000-7,000%'").count,
        'luxury' => Bar.where("price_range LIKE '%¥5,000-8,000%' OR price_range LIKE '%¥6,000-10,000%'").count
      },
      smoking_status: Bar.group(:smoking_status).count
    }
  end
=end
end
