# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
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
#  email_subscribe :boolean          default("true")
#  login_count     :integer          default("0")
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ApplicationRecord
  has_many :user_tags, dependent: :destroy
  has_many :tags, through: :user_tags
  has_many :notifications, dependent: :destroy
  has_many :connections
  has_many :social_links

  validates :username, :email, presence: true




end
