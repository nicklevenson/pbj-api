class NotificationStreamChannel < ApplicationCable::Channel
  def subscribed
    stream_from "notification_stream_#{params[:id]}"
    user = User.find(params[:id])
    notifications = user.notifications.order_by_read.map do |notification|
      NotificationSerializer.new(notification, current_user: user)
    end
    ActionCable.server.broadcast("notification_stream_#{user.id}", notifications)
  end

  def mark_read(data)
    id = params[:id]
    user = User.find(id)
    notification = user.notifications.find(data['notification_id'])
    notification.update!(read: true)
    notifications = user.notifications.order_by_read.map do |notification|
      NotificationSerializer.new(notification, current_user: user)
    end

    ActionCable.server.broadcast("notification_stream_#{user.id}", notifications)
  end

  def unsubscribed; end
end
