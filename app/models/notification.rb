# == Schema Information
#
# Table name: notifications
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  content          :string
#  read             :boolean          default("false")
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

  private

  def user_email
    user = self.user
    UserMailer.with(user: user, notification: self).notification_email.deliver_later if user.email_subscribe
  end

  def stream_to_cable
    ActionCable.server.broadcast("notification_stream_#{user_id}", user.notifications)
  end
end
