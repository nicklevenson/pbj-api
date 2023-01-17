class ChatroomStreamChannel < ApplicationCable::Channel
  def subscribed
    id = params[:id]
    stream_from "chatroom_stream_#{id}"
    user = User.find(id)
    chatrooms = Chatroom.serializable_stream(user)
    ActionCable.server.broadcast("chatroom_stream_#{id}", chatrooms)
  end

  def new_message(data)
    id = params[:id]
    user = User.find(id)
    chatroom = Chatroom.find(data['chatroom_id'])
    chatroom.messages.create!(
      user: user,
      content: data['content']
    )
  end

  def mark_read(data)
    id = params[:id]
    user = User.find(id)
    chatroom = Chatroom.find(data['chatroom_id'])
    chatroom.messages.where.not(user: user).unread.update_all(read_at: Time.zone.now)
    chatrooms = Chatroom.serializable_stream(user)
    ActionCable.server.broadcast("chatroom_stream_#{id}", chatrooms)
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
