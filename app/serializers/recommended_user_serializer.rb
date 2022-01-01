class RecommendedUserSerializer < ActiveModel::Serializer
  attributes :id, :email, :username, :connections, :similarity_score, :tags, :similar_tags

  has_many :tags

  # def initialize(original_user)
  #   @original_user = original_user
  # end

  def connections
    {
      "connected_users": ActiveModel::ArraySerializer.new(object.connected_users.includes(:tags), each_serializer: UserSerializer,
                                                                                                  except: %i[connections user_feed])
    }
  end

  # def similar_tags
  #   og_tag_ids = @original_user.tags.pluck(:id)
  #   rec_tag_ids = object.tags.pluck(:id)
  #   Tag.where(id: og_tag_ids).where(id: rec_tag_ids)
  # end
end
