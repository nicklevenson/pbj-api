# == Schema Information
#
# Table name: chatrooms
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Chatroom < ApplicationRecord
  has_many :messages
  has_many :user_chatrooms
  has_many :users, through: :user_chatrooms
  after_save :stream_to_cable

  def self.serializable_stream(user)
    chatrooms = user.reload.chatrooms.map do |chatroom|
      ChatroomsSerializer.new(chatroom, current_user: user).serializable_hash
    end
  end

  private

  def stream_to_cable
    users.each do |user|
      chatrooms = Chatroom.serializable_stream(user)
      ActionCable.server.broadcast("chatroom_stream_#{user.id}", chatrooms)
    end
  end
end
