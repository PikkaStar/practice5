class Group < ApplicationRecord
  has_many :group_users, dependent: :destroy
  has_many :users, through: :group_users, source: :user
  belongs_to :user
  has_many :permits, dependent: :destroy

  has_many :group_genres, dependent: :destroy
  has_many :genres, through: :group_genres

  validates :name, presence: true
  validates :introduction, presence: true
  has_one_attached :group_image

  def get_group_image(width, height)
    if group_image.attached?
      group_image.variant(resize_to_limit: [width, height]).processed
    else
      "no_image"
    end
  end

  def includesUser?(user)
    group_users.exists?(user_id: user.id)
  end

  def save_genres(genres)
    current_genres = self.genres.pluck(:genre_name) unless self.genres.nil?
    old_genres = current_genres - genres
    new_genres = genres - current_genres

    old_genres.each do |old_name|
      self.genres.delete Genre.find_by(genre_name: old_name)
    end
    new_genres.each do |new_name|
      genre = Genre.find_or_create_by(genre_name: new_name)
      self.genres << genre
    end
  end

  def self.looks(search, word)
    if search == "perfect_match"
      @groups = Group.where("name LIKE?", "#{word}")
    elsif search == "forward_match"
      @groups = Group.where("name LIKE?", "#{word}%")
    elsif search == "backward_match"
      @groups = Group.where("name LIKE?", "%#{word}")
    elsif search == "partial_match"
      @groups = Group.where("name LIKE?", "%#{word}%")
    else
      @groups = Group.all
    end
   end
end
