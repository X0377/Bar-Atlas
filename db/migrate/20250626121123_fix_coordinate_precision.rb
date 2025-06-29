class FixCoordinatePrecision < ActiveRecord::Migration[7.1]
  def up
    change_column :bars, :latitude, :decimal, precision: 10, scale: 6
    change_column :bars, :longitude, :decimal, precision: 10, scale: 6

    add_index :bars, [:latitude, :longitude], name: 'index_bars_on_coordinates'
  end

  def down
    remove_index :bars, name: 'index_bars_on_coordinates'
    change_column :bars, :latitude, :decimal
    change_column :bars, :longitude, :decimal
  end
end
