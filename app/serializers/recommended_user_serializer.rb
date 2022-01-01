class RecommendedUserSerializer < ActiveModel::Serializer
  attributes :id, :email, :username, :similarity_score
end
