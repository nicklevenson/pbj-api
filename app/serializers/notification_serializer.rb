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
class NotificationSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :read, :involved_user, :content

  def involved_user
    return unless object.involved_user

    SupportingUserInfoSerializer.new(@options[:current_user], other_user: object.involved_user).serializable_hash
  end
end
