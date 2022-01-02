class SupportingUserInfoSerializer < ActiveModel::Serializer
  attributes :info, :tags, :connections
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

  def connections
    connected_users = @other_user.connected_users
    similar_connections = connected_users & object.connected_users
    {
      connected_users: connected_users,
      similar_connections: similar_connections
    }
  end
end
