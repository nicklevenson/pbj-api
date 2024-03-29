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

class User < ApplicationRecord
  include ConnectionsModule
  include GeolocationModule
  include SpotifyModule
  has_many :user_tags, dependent: :destroy
  has_many :tags, through: :user_tags
  has_many :notifications, dependent: :destroy
  has_many :social_links
  accepts_nested_attributes_for :social_links

  has_many :requestor_connections, foreign_key: :requestor_id, class_name: :Connection
  has_many :receiver_connections, foreign_key: :receiver_id, class_name: :Connection

  has_many :messages
  has_many :user_chatrooms
  has_many :chatrooms, through: :user_chatrooms

  validates :username, :email, presence: true

  after_create :new_user_notification

  def user_feed(range = nil, instruments = nil, genres = nil)
    range = nil if range >= 500
    RecommendedUsersService.new(user: self, range: range, instruments: instruments, genres: genres).get_recommendation
  end

  # nested helpers
  def tags_attributes=(tags_attributes)
    tags.delete_all
    tags_attributes.each do |tag_attribute|
      tag = Tag.find_or_create_by(name: tag_attribute['name'], link: tag_attribute['link'],
                                  image_url: tag_attribute['image_url'], kind: Tag::KIND_MAPPINGS[:tag_attribute['kind'].to_sym])
      tags << tag unless tags.include?(tag)
    end
  end

  scope :recommendable, -> { where.not(lat: nil).where.not(lng: nil).not_incognito }
  scope :not_incognito, -> { where(incognito: false) }

  private

  def new_user_notification
    notifications << Notification.create(content: "Thanks for joining Matchup Music! We're excited to have you.")
  end
end
