class Bar < ApplicationRecord
  has_many :specialties, dependent: :destroy

  def self.ransackable_attributes(auth_object = nil)
    [
      "address",
      "business_hours",
      "combined_search",
      "created_at",
      "description",
      "id",
      "id_value",
      "image_url",
      "name",
      "phone",
      "price_range",
      "smoking_status",
      "updated_at",
      "price_category",
      "name_or_address_or_phone_or_smoking_status_or_description_or_specialties_category_cont"
    ]
  end

  def self.ransackable_associations(auth_object = nil)
    ["specialties"]
  end

  ransacker :combined_search do
    Arel.sql(%{
      CONCAT(
        COALESCE(bars.name, ''), ' ',
        COALESCE(bars.address, ''), ' ',
        COALESCE(bars.phone, ''), ' ',
        COALESCE(bars.smoking_status, ''), ' ',
        COALESCE(bars.description, ''), ' ',
        COALESCE((
          SELECT string_agg(category, ' ')
          FROM specialties
          WHERE bar_id = bars.id
        ), '')
      )
    })
  end

  ransacker :price_category do
    Arel.sql("CASE
      WHEN bars.price_range IS NULL OR bars.price_range = '' THEN 'unknown'

      -- リーズナブル：下限が4000円以下 または 上限が4500円以下
      WHEN bars.price_range ILIKE '¥1,%'
        OR bars.price_range ILIKE '¥2,%'
        OR bars.price_range ILIKE '¥3,%'
        OR bars.price_range ILIKE '¥4,%'
        OR bars.price_range ILIKE '%-2,%'
        OR bars.price_range ILIKE '%-3,%'
        OR bars.price_range ILIKE '%-4,%'
        THEN 'reasonable'

      -- 高級：下限が8000円以上 または 上限が10000円以上
      WHEN bars.price_range ILIKE '¥8,%'
        OR bars.price_range ILIKE '¥9,%'
        OR bars.price_range ILIKE '¥10,%'
        OR bars.price_range ILIKE '¥12,%'
        OR bars.price_range ILIKE '¥15,%'
        OR bars.price_range ILIKE '¥20,%'
        OR bars.price_range ILIKE '%-8,%'
        OR bars.price_range ILIKE '%-9,%'
        OR bars.price_range ILIKE '%-10,%'
        OR bars.price_range ILIKE '%-12,%'
        OR bars.price_range ILIKE '%-15,%'
        OR bars.price_range ILIKE '%-20,%'
        THEN 'luxury'

      -- 標準：それ以外（5000-8000円台）
      ELSE 'standard'
    END")
  end


  scope :search_by_keywords, ->(keywords_string) {
    return all if keywords_string.blank?

    keywords = keywords_string.gsub(/[　\s]+/, ' ').strip.split(' ')
    result = left_joins(:specialties)

    keywords.each do |keyword|
      next if keyword.blank?

      result = result.where(
        "bars.name ILIKE :keyword OR
          bars.address ILIKE :keyword OR
          bars.phone ILIKE :keyword OR
          bars.smoking_status ILIKE :keyword OR
          bars.description ILIKE :keyword OR
          specialties.category ILIKE :keyword",
        keyword: "%#{keyword}%"
      )
    end

    result.distinct
  }

  # Geocoding関連
  def geocoded?
    latitude.present? && longitude.present?
  end

  def geocode!
    return false if address.blank?

    geocoding_service = GeocodingService.new
    result = geocoding_service.geocode_address(address)

    if result[:success]
      update(
        latitude: result[:latitude],
        longitude: result[:longitude]
      )
      true
    else
      Rails.logger.warn "Geocoding failed for #{name}: #{result[:error]}"
      false
    end
  rescue => e
    Rails.logger.error "Geocoding error for #{name}: #{e.message}"
    false
  end

  def reverse_geocode!
    return false unless geocoded?

    geocoding_service = GeocodingService.new
    result = geocoding_service.reverse_geocode(latitude, longitude)

    if result[:success]
      update(address: result[:address])
      true
    else
      false
    end
  rescue => e
    Rails.logger.error "Reverse geocoding error for #{name}: #{e.message}"
    false
  end

  def self.geocode_all!
    where(latitude: nil).find_each do |bar|
      bar.geocode!
      sleep(0.1) # API制限回避
    end
  end
end
