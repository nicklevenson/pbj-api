class ChatroomStreamChannel < ApplicationCable::Channel
  def subscribed
    id = current_user.id
    stream_from "chatroom_stream_#{id}"
    chatrooms = Chatroom.serializable_stream(current_user)
    ActionCable.server.broadcast("chatroom_stream_#{id}", chatrooms)
  end

  def new_message(data)
    chatroom = Chatroom.find(data['chatroom_id'])

    chatroom.messages.create!(
      user: current_user,
      content: data['content']
    )
  end

  def mark_read(data)
    chatroom = Chatroom.find(data['chatroom_id'])
    chatroom.messages.where.not(user: current_user).unread.update_all(read_at: Time.zone.now)
    chatrooms = Chatroom.serializable_stream(current_user)
    ActionCable.server.broadcast("chatroom_stream_#{current_user.id}", chatrooms)
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
