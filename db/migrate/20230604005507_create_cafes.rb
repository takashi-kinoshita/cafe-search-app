class CreateCafes < ActiveRecord::Migration[7.0]
  def change
    create_table :cafes do |t|
      t.string :name
      t.string :address
      t.float :latitude
      t.float :longitude
      t.string :phone
      t.string :opening
      t.string :closed
      t.string :images

      t.timestamps
    end
  end
end
