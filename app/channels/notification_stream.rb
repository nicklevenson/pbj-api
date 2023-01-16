class NotificationStreamChannel < ApplicationCable::Channel
  def subscribed
    stream_from "notification_stream_#{params[:id]}"
    user = User.find(params[:id])
    ActionCable.server.broadcast("notification_stream_#{user.id}", user.notifications)
  end

  def unsubscribed; end
end
