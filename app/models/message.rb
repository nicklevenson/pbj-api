# == Schema Information
#
# Table name: messages
#
#  id          :integer          not null, primary key
#  chatroom_id :integer
#  user_id     :integer
#  content     :text
#  read_at     :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Message < ApplicationRecord
  belongs_to :chatroom
  belongs_to :user

  validates :content, presence: true

  after_save :stream_to_cable, :message_notification

  private

  def stream_to_cable
    user.reload
    current_user_chatrooms = Chatroom.serializable_stream(user)
    other_user = chatroom.users.where.not(id: user.id).first
    other_user_chatrooms = Chatroom.serializable_stream(other_user)
    ActionCable.server.broadcast("chatroom_stream_#{other_user.id}", other_user_chatrooms)
    ActionCable.server.broadcast("chatroom_stream_#{user_id}", current_user_chatrooms)
  end

  def message_notification
    # MessagingNotificationJob.set(wait: 30.minutes).perform_later(self)
  end

  scope :unread, -> {where(read_at: nil)}
end
