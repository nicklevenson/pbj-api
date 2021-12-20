# == Schema Information
#
# Table name: rejections
#
#  id          :integer          not null, primary key
#  rejector_id :integer
#  rejected_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Rejection < ApplicationRecord
end
