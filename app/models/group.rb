class Group < ApplicationRecord
  has_many :group_users,dependent: :destroy
  has_many :users,through: :group_users,source: :user
  belongs_to :user
  has_many :group_messages,dependent: :destroy
  has_many :permits,dependent: :destroy

  has_many :group_messages,dependent: :destroy


  validates :name, presence: true
  validates :introduction, presence: true
  has_one_attached :group_image

         def get_group_image(width,height)
           if group_image.attached?
             group_image.variant(resize_to_limit: [width,height]).processed
           else
             "no_image"
           end
         end

         def includesUser?(user)
           group_users.exists?(user_id: user.id)
         end

         def self.looks(search,word)
           if search == "perfect_match"
              @groups = Group.where("name LIKE?","#{word}")
              elsif search == "forward_match"
              @groups = Group.where("name LIKE?","#{word}%")
              elsif search == "backward_match"
              @groups = Group.where("name LIKE?","%#{word}")
              elsif search == "partial_match"
              @groups = Group.where("name LIKE?","%#{word}%")
              else
              @groups = Group.all
              end
          end

end
