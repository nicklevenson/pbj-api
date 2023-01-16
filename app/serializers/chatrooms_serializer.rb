class ChatroomsSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :updated_at, :messages, :has_unread?, :other_user_info

  def messages
    object.messages.map do |message|
      MessagesSerializer.new(message).serializable_hash
    end
  end

  def has_unread?
    object.messages.where(read_at: nil).where.not(user_id: current_user.id).pluck(:id).any?
  end

  def current_user
    @options[:current_user]
  end

  def other_user_info
    user = object.users.where.not(id: current_user.id).first
    SupportingUserInfoSerializer.new(@options[:current_user], other_user: user).serializable_hash
  end
end
