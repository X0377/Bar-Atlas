class Bar < ApplicationRecord
  has_many :specialties, dependent: :destroy

  def self.ransackable_attributes(auth_object = nil)
    ["name", "address", "phone", "price_range", "smoking_status", "description", "business_hours", "created_at", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["specialties"]
  end
end
