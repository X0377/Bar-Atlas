class BarsController < ApplicationController
  before_action :set_bar, only: %i[show]

  def index
    @bars = build_filtered_query
    @total_count = @bars.distinct.count('bars.id')

    @bars = apply_sorting(@bars)

    @bars = @bars.group('bars.id')

    @bars = @bars.page(params[:page]).per(20)

    map_base_query = build_filtered_query.where.not(latitude: nil, longitude: nil)

    @bars_for_map_count = map_base_query.group('bars.id').count.size

    @bars_for_map = map_base_query
                    .group('bars.id')
                    .select(:id, :name, :address, :phone, :business_hours,
                           :price_range, :latitude, :longitude, :smoking_status)
                    .limit(100)
  end

  def show
    @bar = Bar.find(params[:id])
  end

  private

  def build_filtered_query
    keyword_search = params.dig(:q, :name_or_address_or_phone_or_smoking_status_or_description_or_specialties_category_cont)
    other_params = params.fetch(:q, {}).except(:name_or_address_or_phone_or_smoking_status_or_description_or_specialties_category_cont)
                        .reject { |key, value| value.blank? }

    @q = Bar.ransack(other_params)
    bars = @q.result.includes(:specialties)

    if keyword_search.present?
      bars = bars.search_by_keywords(keyword_search)
    end

    if params.dig(:q, :specialties_category_eq).present?
      specialty_category = params.dig(:q, :specialties_category_eq)
      bars = bars.where(
        "EXISTS (SELECT 1 FROM specialties WHERE specialties.bar_id = bars.id AND specialties.category = ?)",
        specialty_category
      )
    end

    bars
  end

  def set_bar
    @bar = Bar.find(params[:id])
  end

  def search_performed?
    params[:q].present? && params[:q].values.any?(&:present?)
  end
  helper_method :search_performed?

  def apply_sorting(relation)
    case params[:sort]
    when 'created_at_desc'
      relation.order('bars.created_at DESC')
    when 'name_asc'
      relation.order('bars.name ASC')
    when 'name_desc'
      relation.order('bars.name DESC')
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
    when 'price_max_asc'
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
      apply_sorting_with_param('price_min_asc', relation)
    when 'price_desc'
      apply_sorting_with_param('price_min_desc', relation)
    else
      relation.order('bars.created_at DESC')
    end
  end

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
