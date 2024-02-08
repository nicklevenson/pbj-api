# == Schema Information
#
# Table name: user_tags
#
#  id         :bigint           not null, primary key
#  user_id    :integer
#  tag_id     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe UserTag, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
