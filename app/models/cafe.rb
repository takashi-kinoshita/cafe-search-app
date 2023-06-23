class Cafe < ApplicationRecord
  self.table_name = 'cafes'
  has_many :favorites
  has_many :users, through: :favorites
  scope :by_name, -> (name) { where("name LIKE ?", "%#{name}%") if name.present? }
  scope :by_location, -> (location) { where(location: location) if location.present? }
  scope :order_by_recent, -> { order(created_at: :desc) }
  geocoded_by :address
  after_validation :geocode
end
