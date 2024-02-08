# == Schema Information
#
# Table name: social_links
#
#  id         :bigint           not null, primary key
#  user_id    :integer
#  type       :integer
#  url        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class SocialLink < ApplicationRecord
  self.inheritance_column = nil

  belongs_to :user

  enum type: %i[spotify soundcloud bandcamp instagram apple_music]
end
