class BarsController < ApplicationController
  before_action :set_bar, only: %i[show]

  def index
    @q = Bar.ransack(search_params)
    @bars = @q.result.includes(:specialties)

    @bars = apply_sorting(@bars)

    if helpers.search_performed?
      @bars = @bars.page(params[:page]).per(20)
    else
      @bars = @bars.limit(12)
    end

    @total_count = @q.result.count if helpers.search_performed?
  end

  def show
    @bar = Bar.find(params[:id])
  end

  private

  def set_bar
    @bar = Bar.find(params[:id])
  end

  # 後日実装予定
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

  def search_params
    params.fetch(:q, {}).permit(
      :name_cont,           # バー名部分一致
      :address_cont,        # 住所部分一致
      :price_range_eq,      # 価格帯完全一致
      :smoking_status_eq,   # 喫煙状況完全一致
      :description_cont,    # 説明部分一致
      :phone_cont,          # 電話番号部分一致
      :business_hours_cont, # 営業時間部分一致
      :s                    # ソート条件
    )
  end
end
