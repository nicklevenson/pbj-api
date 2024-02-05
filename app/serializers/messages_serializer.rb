class MessagesSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :updated_at, :content, :user_id, :read_at
end
