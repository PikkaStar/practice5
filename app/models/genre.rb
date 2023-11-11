class Genre < ApplicationRecord
  has_many :group_genres,dependent: :destroy
  has_many :groups,through: :group_genres
end
