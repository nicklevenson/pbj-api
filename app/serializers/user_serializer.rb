# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  username        :string
#  email           :string
#  photo           :string
#  location        :string           default("Earth")
#  bio             :text
#  uid             :string
#  provider        :string
#  providerImage   :string           default("https://icon-library.net//images/no-user-image-icon/no-user-image-icon-27.jpg")
#  token           :string
#  refresh_token   :string
#  lng             :decimal(10, 6)
#  lat             :decimal(10, 6)
#  email_subscribe :boolean          default(TRUE)
#  login_count     :integer          default(0)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  incognito       :boolean          default(FALSE)
#
class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :username, :bio, :location, :photo, :login_count, :connections, :tags, :social_links, :needs_welcome_step
  
  def connections
    {
      "connected_users": connected_users,
      "pending_connections": pending_connections,
      "incoming_connections": incoming_connections
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

  def connected_users
    object.connected_users.map do |user|
      SupportingUserInfoSerializer.new(object, other_user: user).serializable_hash
    end
  end

  def pending_connections
    object.pending_connections.map do |user|
      SupportingUserInfoSerializer.new(object, other_user: user).serializable_hash
    end
  end

  def incoming_connections
    object.incoming_connections.map do |user|
      SupportingUserInfoSerializer.new(object, other_user: user).serializable_hash
    end
  end

  def needs_welcome_step
    (object.photo.nil? || object.tags.empty? || object.lat.nil? || object.lng.nil? || object.lng.nil?)
  end
end
