# == Schema Information
#
# Table name: chatrooms
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Chatroom < ApplicationRecord
  has_many :messages
  has_many :user_chatrooms
  has_many :users, through: :user_chatrooms
end
