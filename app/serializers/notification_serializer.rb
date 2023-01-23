class NotificationSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :read, :involved_user, :content

  def involved_user
    return unless object.involved_user

    SupportingUserInfoSerializer.new(@options[:current_user], other_user: object.involved_user).serializable_hash
  end
end
