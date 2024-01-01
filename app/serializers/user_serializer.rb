class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :username, :bio, :location, :photo, :login_count, :providerImage, :connections, :tags

  def connections
    {
      "connected_users": connected_users,
      "pending_connections": pending_connections,
      "incoming_connections": incoming_connections
    }
  end

  def tags
    {
      instruments: object.tags.instrument,
      genres: object.tags.genre,
      generic: object.tags.generic,
      spotify: object.tags.spotify
    }
  end

  def connected_users
    object.connected_users.map do |user|
      SupportingUserInfoSerializer.new(object, other_user: user).serializable_hash
    end
  end

  def pending_connections
    object.pending_connections.map do |user|
      SupportingUserInfoSerializer.new(object, other_user: user).serializable_hash
    end
  end

  def incoming_connections
    object.incoming_connections.map do |user|
      SupportingUserInfoSerializer.new(object, other_user: user).serializable_hash
    end
  end
end
