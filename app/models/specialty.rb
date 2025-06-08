class Specialty < ApplicationRecord
  belongs_to :bar

  # Ransack検索許可設定
  def self.ransackable_attributes(auth_object = nil)
    ["category", "description", "is_main"]
  end
end
