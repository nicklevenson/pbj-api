# == Schema Information
#
# Table name: tags
#
#  id         :integer          not null, primary key
#  kind       :integer          default("0")
#  name       :string
#  image_url  :string
#  link       :string
#  uri        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Tag < ApplicationRecord
  has_many :usertags, dependent: :destroy
  has_many :users, through: :usertags
end
