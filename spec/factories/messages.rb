# == Schema Information
#
# Table name: messages
#
#  id          :integer          not null, primary key
#  chatroom_id :integer
#  user_id     :integer
#  content     :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryBot.define do
  factory :message do
    
  end
end
