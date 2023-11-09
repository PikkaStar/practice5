class GroupEntry < ApplicationRecord
  belongs_to :user
  belongs_to :group_room
end
