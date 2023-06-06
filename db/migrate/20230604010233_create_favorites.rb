class CreateFavorites < ActiveRecord::Migration[7.0]
  def change
    create_table :favorites do |t|
      t.integer :user_id
      t.integer :shop_id
      t.datetime :created_at
      t.datetime :updated_at

      t.timestamps
    end
  end
end
