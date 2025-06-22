class Bar < ApplicationRecord
  has_many :specialties, dependent: :destroy

  # セキュリティ対策のためRansackで検索可能な属性を明示的に許可
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
      "updated_at"
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
