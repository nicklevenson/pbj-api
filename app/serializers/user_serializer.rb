class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :username, :connections, :user_feed

  has_many :tags

  def connections
    { "connected_users": ActiveModel::ArraySerializer.new(object.connected_users, each_serializer: UserSerializer,
                                                                                  except: %i[connections user_feed]) }
  end
end
