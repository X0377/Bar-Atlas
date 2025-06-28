class AddLatitudeLongitudeToBars < ActiveRecord::Migration[7.1]
  def change
    add_column :bars, :latitude, :decimal
    add_column :bars, :longitude, :decimal
  end
end
