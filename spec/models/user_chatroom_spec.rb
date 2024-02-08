# == Schema Information
#
# Table name: user_chatrooms
#
#  id          :bigint           not null, primary key
#  chatroom_id :integer
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

RSpec.describe UserChatroom, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
