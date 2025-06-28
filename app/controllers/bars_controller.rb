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

    @bars = @bars.group('bars.id')
    @total_count = @bars.count

    # ページネーション
    @bars = @bars.page(params[:page]).per(20)

    @bars_for_map_query = @q.result.includes(:specialties)

    if keyword_search.present?
      @bars_for_map_query = @bars_for_map_query.search_by_keywords(keyword_search)
    end
    @bars_for_map_query = @bars_for_map_query.where.not(latitude: nil, longitude: nil)

    @bars_for_map_count = @bars_for_map_query.group('bars.id').count.size
    @bars_for_map = @bars_for_map_query.group('bars.id').select(:id, :name, :address, :phone, :business_hours,
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
      relation.order('bars.created_at DESC')
    when 'name_asc'
      relation.order('bars.name ASC')
    when 'name_desc'
      relation.order('bars.name DESC')

    # 価格ソート
    when 'price_min_asc'
      # 下限価格が安い順
      relation.order(Arel.sql("
        MIN(CASE
          WHEN bars.price_range IS NULL OR bars.price_range = '' THEN 0
          ELSE CAST(
            REGEXP_REPLACE(
              SPLIT_PART(REPLACE(bars.price_range, '¥', ''), '-', 1),
              '[^0-9]', '', 'g'
            ) AS INTEGER
          )
        END) ASC, bars.id ASC
      "))
    when 'price_min_desc'
      # 下限価格が高い順
      relation.order(Arel.sql("
        MIN(CASE
          WHEN bars.price_range IS NULL OR bars.price_range = '' THEN 0
          ELSE CAST(
            REGEXP_REPLACE(
              SPLIT_PART(REPLACE(bars.price_range, '¥', ''), '-', 1),
              '[^0-9]', '', 'g'
            ) AS INTEGER
          )
        END) DESC, bars.id ASC
      "))
    when 'price_max_asc'
      # 上限価格が安い順
      relation.order(Arel.sql("
        MIN(CASE
          WHEN bars.price_range IS NULL OR bars.price_range = '' THEN 0
          WHEN POSITION('-' IN bars.price_range) = 0 THEN
            CAST(
              REGEXP_REPLACE(
                REPLACE(bars.price_range, '¥', ''),
                '[^0-9]', '', 'g'
              ) AS INTEGER
            )
          ELSE CAST(
            REGEXP_REPLACE(
              SPLIT_PART(REPLACE(bars.price_range, '¥', ''), '-', 2),
              '[^0-9]', '', 'g'
            ) AS INTEGER
          )
        END) ASC, bars.id ASC
      "))
    when 'price_max_desc'
      # 上限価格が高い順
      relation.order(Arel.sql("
        MIN(CASE
          WHEN bars.price_range IS NULL OR bars.price_range = '' THEN 0
          WHEN POSITION('-' IN bars.price_range) = 0 THEN
            CAST(
              REGEXP_REPLACE(
                REPLACE(bars.price_range, '¥', ''),
                '[^0-9]', '', 'g'
              ) AS INTEGER
            )
          ELSE CAST(
            REGEXP_REPLACE(
              SPLIT_PART(REPLACE(bars.price_range, '¥', ''), '-', 2),
              '[^0-9]', '', 'g'
            ) AS INTEGER
          )
        END) DESC, bars.id ASC
      "))
    when 'price_average_asc'
      # 平均価格が安い順
      relation.order(Arel.sql("
        MIN((
          CAST(
            REGEXP_REPLACE(
              SPLIT_PART(REPLACE(bars.price_range, '¥', ''), '-', 1),
              '[^0-9]', '', 'g'
            ) AS INTEGER
          ) +
          CASE
            WHEN POSITION('-' IN bars.price_range) = 0 THEN
              CAST(
                REGEXP_REPLACE(
                  REPLACE(bars.price_range, '¥', ''),
                  '[^0-9]', '', 'g'
                ) AS INTEGER
              )
            ELSE CAST(
              REGEXP_REPLACE(
                SPLIT_PART(REPLACE(bars.price_range, '¥', ''), '-', 2),
                '[^0-9]', '', 'g'
              ) AS INTEGER
            )
          END
        ) / 2) ASC, bars.id ASC
      "))
    when 'price_average_desc'
      # 平均価格が高い順
      relation.order(Arel.sql("
        MIN((
          CAST(
            REGEXP_REPLACE(
              SPLIT_PART(REPLACE(bars.price_range, '¥', ''), '-', 1),
              '[^0-9]', '', 'g'
            ) AS INTEGER
          ) +
          CASE
            WHEN POSITION('-' IN bars.price_range) = 0 THEN
              CAST(
                REGEXP_REPLACE(
                  REPLACE(bars.price_range, '¥', ''),
                  '[^0-9]', '', 'g'
                ) AS INTEGER
              )
            ELSE CAST(
              REGEXP_REPLACE(
                SPLIT_PART(REPLACE(bars.price_range, '¥', ''), '-', 2),
                '[^0-9]', '', 'g'
              ) AS INTEGER
            )
          END
        ) / 2) DESC, bars.id ASC
      "))
    when 'price_asc'
      # 既存の価格安い順 → 下限価格安い順にフォールバック
      apply_sorting_with_param('price_min_asc', relation)
    when 'price_desc'
      # 既存の価格高い順 → 下限価格高い順にフォールバック  
      apply_sorting_with_param('price_min_desc', relation)
    else
      relation.order('bars.created_at DESC')
    end
  end

  # ヘルパーメソッド（再帰を避けるため）
  def apply_sorting_with_param(sort_type, relation)
    case sort_type
    when 'price_min_asc'
      relation.order(Arel.sql("
        MIN(CASE
          WHEN bars.price_range IS NULL OR bars.price_range = '' THEN 0
          ELSE CAST(
            REGEXP_REPLACE(
              SPLIT_PART(REPLACE(bars.price_range, '¥', ''), '-', 1),
              '[^0-9]', '', 'g'
            ) AS INTEGER
          )
        END) ASC, bars.id ASC
      "))
    when 'price_min_desc'
      relation.order(Arel.sql("
        MIN(CASE
          WHEN bars.price_range IS NULL OR bars.price_range = '' THEN 0
          ELSE CAST(
            REGEXP_REPLACE(
              SPLIT_PART(REPLACE(bars.price_range, '¥', ''), '-', 1),
              '[^0-9]', '', 'g'
            ) AS INTEGER
          )
        END) DESC, bars.id ASC
      "))
    else
      relation
    end
  end

  def bar_params
    params.require(:bar).permit(
      :name, :address, :price_range, :smoking_status,
      :description, :phone, :business_hours, :image_url
    )
  end
end
