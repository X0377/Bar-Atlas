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
      WHEN bars.price_range LIKE '%¥5,000-8,000%' OR bars.price_range LIKE '%¥6,000-10,000%' THEN 'luxury'
      WHEN bars.price_range LIKE '%¥3,000-5,000%' OR bars.price_range LIKE '%¥4,000-7,000%' THEN 'standard'
      WHEN bars.price_range LIKE '%¥2,000-4,000%' OR bars.price_range LIKE '%¥2,500-4,500%' THEN 'reasonable'
      ELSE 'unknown'
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
end
