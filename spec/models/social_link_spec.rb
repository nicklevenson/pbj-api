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

require 'rails_helper'

RSpec.describe SocialLink, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
