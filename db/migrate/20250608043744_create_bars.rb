class CreateBars < ActiveRecord::Migration[7.1]
  def change
    create_table :bars do |t|
      t.string :name
      t.string :address
      t.string :price_range
      t.string :smoking_status
      t.text :description

      t.timestamps
    end
  end
end
