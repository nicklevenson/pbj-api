class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :username, :bio, :location, :photo, :login_count, :providerImage, :connections, :tags

  def connections
    {
      "connected_users": ActiveModel::ArraySerializer.new(object.connected_users.includes(:tags), each_serializer: UserSerializer,
                                                                                                  except: %i[connections user_feed]),
      "pending_connections": ActiveModel::ArraySerializer.new(object.pending_connections.includes(:tags), each_serializer: UserSerializer,
                                                                                                          except: %i[connections user_feed]),
      "incoming_connections": ActiveModel::ArraySerializer.new(object.incoming_connections.includes(:tags), each_serializer: UserSerializer,
                                                                                                            except: %i[connections user_feed])
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
end
