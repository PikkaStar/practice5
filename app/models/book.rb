class Book < ApplicationRecord
  validates :title,presence: true
  validates :body,presence: true,length: {maximum: 200}
  belongs_to :user
  has_many :favorites,dependent: :destroy
  has_many :book_comments,dependent: :destroy

  scope :latest, -> {order(created_at: :desc)}
  scope :old, -> {order(created_at: :asc)}
  scope :favorite_count, -> {Book.includes(:favorites).sort {|a,b| b.favorites.size <=> a.favorites.size}}
  scope :comment_count, -> {Book.includes(:book_comments).sort {|a,b| b.book_comments.size <=> a.book_comments.size}}

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

    def self.looks(search,word)
      if search == "perfect_match"
        @book = Book.where("title LIKE?","#{word}")
        elsif search == "forward_match"
        @book = Book.where("title LIKE?","#{word}%")
        elsif search == "backward_match"
        @book = Book.where("title LIKE?","%#{word}")
        elsif search == "partial_match"
        @book = Book.where("title LIKE?","%#{word}%")
        else
        @book = Book.all
        end
        end
    end
