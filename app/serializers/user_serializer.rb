class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :username, :connections, :feed, :similarity

  has_many :tags

  def connections
    { "connected_users": ActiveModel::ArraySerializer.new(object.connected_users.includes(:tags), each_serializer: UserSerializer,
                                                                                                  except: %i[connections user_feed]) }
  end

  def feed
    ActiveModel::ArraySerializer.new(object.user_feed.includes(:tags), each_serializer: UserSerializer,
                                                                       except: %i[connections user_feed feed])
  end

  def similarity
    object.similarity_score if object.try(:similarity_score)
  end
end
