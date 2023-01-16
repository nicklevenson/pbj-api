class ChatroomStreamChannel < ApplicationCable::Channel
  def subscribed
    id = params[:id]
    stream_from "chatroom_stream_#{id}"
    user = User.find(id)
    chatrooms = Chatroom.serializable_stream(user.chatrooms)
    ActionCable.server.broadcast("chatroom_stream_#{id}", chatrooms)
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
