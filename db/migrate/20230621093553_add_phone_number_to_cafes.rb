class AddPhoneNumberToCafes < ActiveRecord::Migration[7.0]
  def change
    add_column :cafes, :phone_number, :string
  end
end
