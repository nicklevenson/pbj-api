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
    similar_tags = object.similar_tags(@other_user.id)
    instruments = @other_user.tags.instrument
    genres = @other_user.tags.genre
    generic_tags = @other_user.tags.generic
    spotify_tags = @other_user.tags.spotify

    {
      similar_tags: similar_tags,
      instruments: instruments,
      genres: genres,
      generic_tags: generic_tags,
      spotify_tags: spotify_tags
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
