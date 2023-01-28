class SupportingUserInfoSerializer < ActiveModel::Serializer
  attributes :info, :tags, :connections, :distance, :connection_status, :chatroom_id
  def initialize(*args)
    super
    @other_user = @options[:other_user]
  end

  def info
    UserSerializer.new(@other_user, except: %i[tags connections], root: false)
  end

  def tags
    {
      similar_tags: object.similar_tags(@other_user.id),
      instruments: @other_user.tags.instrument,
      genres: @other_user.tags.genre,
      generic: @other_user.tags.generic,
      spotify: @other_user.tags.spotify
    }
  end

  def connection_status
    if object.connected_users.find_by(id: @other_user.id)
      'connected'
    elsif object.incoming_connections.find_by(id: @other_user.id)
      'incoming request'
    elsif object.pending_connections.find_by(id: @other_user.id)
      'pending'
    else
      'unconnected'
    end
  end

  def connections
    connected_users = @other_user.connected_users
    similar_connections = connected_users & object.connected_users
    {
      connected_users: connected_users,
      similar_connections: similar_connections
    }
  end

  def distance
    object.user_distance(@other_user).to_i
  end

  def chatroom_id
    object.chatrooms.where(id: @other_user.chatrooms.pluck(:id))&.first&.id
  end
end
