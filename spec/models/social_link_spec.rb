# == Schema Information
#
# Table name: social_links
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  soundcloud_link  :string
#  bandcamp_link    :string
#  youtube_link     :string
#  spotify_link     :string
#  apple_music_link :string
#  instagram_link   :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require 'rails_helper'

RSpec.describe SocialLink, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
