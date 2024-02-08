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

FactoryBot.define do
  factory :user_chatroom do
    
  end
end
