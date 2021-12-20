# == Schema Information
#
# Table name: social_links
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  type       :integer
#  url        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class SocialLink < ApplicationRecord
  belongs_to :user
end
