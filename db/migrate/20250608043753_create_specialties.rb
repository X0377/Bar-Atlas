class CreateSpecialties < ActiveRecord::Migration[7.1]
  def change
    create_table :specialties do |t|
      t.references :bar, null: false, foreign_key: true
      t.string :category
      t.boolean :is_main
      t.text :description

      t.timestamps
    end
  end
end
