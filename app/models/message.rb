# == Schema Information
#
# Table name: messages
#
#  id          :integer          not null, primary key
#  chatroom_id :integer
#  user_id     :integer
#  content     :text
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
    chatrooms = MultiJson.dump(user.chatrooms, include: %i[users messages])
    ActionCable.server.broadcast("chatroom_stream_#{user_id}", chatrooms)
  end

  def message_notification
    # MessagingNotificationJob.set(wait: 30.minutes).perform_later(self)
  end
end
