class GroupMessage < ApplicationRecord
  belongs_to :user
  belongs_to :group_room
end
