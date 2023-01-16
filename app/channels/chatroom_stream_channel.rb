class ChatroomStreamChannel < ApplicationCable::Channel
  def subscribed
    id = params[:id]
    stream_from "chatroom_stream_#{id}"
    user = User.find(id)
    chatrooms = user.chatrooms.map do |chatroom|
      ChatroomsSerializer.new(chatroom, current_user: user).serializable_hash
    end
    ActionCable.server.broadcast("chatroom_stream_#{id}", chatrooms)
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
