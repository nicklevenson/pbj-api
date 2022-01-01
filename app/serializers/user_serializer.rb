class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :username, :connections

  has_many :tags

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
end
