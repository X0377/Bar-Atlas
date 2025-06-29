class Specialty < ApplicationRecord
  belongs_to :bar


  def self.ransackable_attributes(auth_object = nil)
    ["bar_id", "category", "created_at", "description", "id", "id_value", "is_main", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["bar"]
  end
end
