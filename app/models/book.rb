class Book < ApplicationRecord
  validates :title, presence: true
  validates :body, presence: true, length: { maximum: 200 }
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy

  has_many :book_tags, dependent: :destroy
  has_many :tags, through: :book_tags

  scope :latest, -> { order(created_at: :desc) }
  scope :old, -> { order(created_at: :asc) }
  scope :favorite_count, -> { Book.includes(:favorites).sort { |a, b| b.favorites.size <=> a.favorites.size } }
  scope :comment_count, -> { Book.includes(:book_comments).sort { |a, b| b.book_comments.size <=> a.book_comments.size } }

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  def save_tags(tags)
    current_tags = self.tags.pluck(:name) unless self.tags.nil?
    old_tags = current_tags - tags
    new_tags = tags - current_tags

    old_tags.each do |old_name|
      self.tags.delete Tag.find_by(name: old_name)
    end

    new_tags.each do |new_name|
      tag = Tag.find_or_create_by(name: new_name)
      self.tags << tag
    end
  end

  def self.looks(search, word)
    if search == "perfect_match"
      @book = Book.where("title LIKE?", "#{word}")
    elsif search == "forward_match"
      @book = Book.where("title LIKE?", "#{word}%")
    elsif search == "backward_match"
      @book = Book.where("title LIKE?", "%#{word}")
    elsif search == "partial_match"
      @book = Book.where("title LIKE?", "%#{word}%")
    else
      @book = Book.all
    end
  end

  # postへのいいね通知機能
 def create_notification_favorite_book!(current_user)
   # 同じユーザーが同じ投稿に既にいいねしていないかを確認
   existing_notification = Notification.find_by(book_id: self.id, visitor_id: current_user.id, action: "favorite_book")

   # すでにいいねされていない場合のみ通知レコードを作成
   if existing_notification.nil? && current_user != self.user
     notification = Notification.new(
       book_id: self.id,
       visitor_id: current_user.id,
       visited_id: self.user.id,
       action: "favorite_book"
     )

     if notification.valid?
       notification.save
     end
   end
 end

end
