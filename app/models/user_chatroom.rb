# == Schema Information
#
# Table name: user_chatrooms
#
#  id          :bigint           not null, primary key
#  chatroom_id :integer
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class UserChatroom < ApplicationRecord
  belongs_to :user
  belongs_to :chatroom

  default_scope { order(created_at: :asc) }
end
