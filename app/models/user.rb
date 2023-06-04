class User < ApplicationRecord
  has_many :favorites
  has_many :cafes, through: :favorites
end
