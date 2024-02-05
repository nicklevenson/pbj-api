class NotificationStreamChannel < ApplicationCable::Channel
  def subscribed
    id = current_user.id
    stream_from "notification_stream_#{id}"

    notifications = current_user.notifications.order_by_read.map do |notification|
      NotificationSerializer.new(notification, current_user: current_user)
    end
    ActionCable.server.broadcast("notification_stream_#{current_user.id}", notifications)
  end

  def mark_read(data)
    notification = current_user.notifications.find(data['notification_id'])
    notification.update!(read: true)
    notifications = current_user.notifications.order_by_read.map do |notification|
      NotificationSerializer.new(notification, current_user: current_user)
    end

    ActionCable.server.broadcast("notification_stream_#{current_user.id}", notifications)
  end

  def unsubscribed; end
end
