class AddPhoneAndBusinessHoursToBars < ActiveRecord::Migration[7.1]
  def change
    add_column :bars, :phone, :string
    add_column :bars, :business_hours, :string
  end
end
