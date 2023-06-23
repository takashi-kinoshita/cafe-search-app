class AddDescriptionToCafes < ActiveRecord::Migration[7.0]
  def change
    add_column :cafes, :description, :string
  end
end
