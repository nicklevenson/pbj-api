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

  # after_create :user_email

  def self.make_read(ids)
    Notification.where(id: ids).update_all(read: true)
  end

  private

  def user_email
    user = self.user
    if user.email_subscribe
      UserMailer.with(user: user, notification: self).notification_email.deliver_later
    end
  end
end
