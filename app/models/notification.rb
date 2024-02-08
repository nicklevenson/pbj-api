# == Schema Information
#
# Table name: notifications
#
#  id               :bigint           not null, primary key
#  user_id          :integer
#  content          :string
#  read             :boolean          default(FALSE)
#  involved_user_id :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :involved_user, class_name: :User
  # after_create :user_email
  after_create :stream_to_cable

  def self.make_read(ids)
    Notification.where(id: ids).update_all(read: true)
  end

  scope :order_by_read, -> { order(:read).order('created_at desc') }

  private

  def user_email
    user = self.user
    UserMailer.with(user: user, notification: self).notification_email.deliver_later if user.email_subscribe
  end

  def stream_to_cable
    notifications = user.notifications.order_by_read.map do |notification|
      NotificationSerializer.new(notification, current_user: user)
    end
    ActionCable.server.broadcast("notification_stream_#{user_id}", notifications)
  end
end
